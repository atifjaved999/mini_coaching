require 'rails_helper'

RSpec.describe Session, type: :model do
  let(:session) { build(:session) }
  let(:coach) { create(:user) }
  let(:client) { create(:user) }

  before do
    coach.add_role(:coach)
    client.add_role(:client)
  end

  describe 'associations' do
    it { should have_many(:session_users).dependent(:destroy) }
    it { should have_many(:users).through(:session_users) }
  end

  describe 'validations' do
    it 'validates session time conflict' do
      existing_session = create(:session, 
        scheduled_at: Date.today,
        start_time: '10:00',
        end_time: '11:00'
      )

      new_session = build(:session,
        scheduled_at: Date.today,
        start_time: '10:30',
        end_time: '11:30'
      )

      expect(new_session).not_to be_valid
      expect(new_session.errors[:base]).to include('A session already exists during this time frame on the same date.')
    end
  end

  describe '#coaches' do
    it 'returns only coach users' do
      session.users << coach
      session.users << client
      session.save

      expect(session.coaches).to include(coach)
      expect(session.coaches).not_to include(client)
    end
  end

  describe '#clients' do
    it 'returns only client users' do
      session.users << coach
      session.users << client
      session.save

      expect(session.clients).to include(client)
      expect(session.clients).not_to include(coach)
    end
  end
end
