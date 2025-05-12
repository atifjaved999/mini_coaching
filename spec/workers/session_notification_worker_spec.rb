require 'rails_helper'

RSpec.describe SessionNotificationWorker, type: :worker do
  describe '#perform' do
    let(:session) { create(:session, :with_users) }
    let(:mailer) { double('mailer') }

    before do
      allow(SessionMailer).to receive(:session_notification).and_return(mailer)
      allow(mailer).to receive(:deliver_later)
    end

    it 'enqueues email notifications for all users in the session' do
      session.users.each do |user|
        expect(SessionMailer).to receive(:session_notification).with(user, session)
      end
      expect(mailer).to receive(:deliver_later).with(wait: 5.seconds).exactly(session.users.count).times

      described_class.new.perform(session.id)
    end

    context 'when email enqueuing fails' do
      before do
        allow(mailer).to receive(:deliver_later).and_raise(StandardError.new('Email enqueuing failed'))
      end

      it 'logs the error and raises it for retry' do
        expect(Rails.logger).to receive(:error).with(/Failed to send session notification email/)
        expect { described_class.new.perform(session.id) }.to raise_error(StandardError)
      end
    end
  end
end
