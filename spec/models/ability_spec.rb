require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  context 'when user is an admin' do
    let(:user) { create(:user) }
    before { user.roles << create(:role, name: 'admin') }

    it { is_expected.to be_able_to(:manage, :all) }
  end

  context 'when user is a coach' do
    let(:user) { create(:user) }
    let(:own_session) { create(:session) }
    let(:other_session) { create(:session) }
    let(:client) { create(:user) }
    
    before do
      user.roles << create(:role, name: 'coach')
      own_session.users << user
      client.roles << create(:role, name: 'client')
      own_session.users << client
    end

    it { is_expected.to be_able_to(:create, Session) }
    it { is_expected.to be_able_to(:read, own_session) }
    it { is_expected.to be_able_to(:update, own_session) }
    it { is_expected.to be_able_to(:destroy, own_session) }
    it { is_expected.not_to be_able_to(:manage, other_session) }
    it { is_expected.to be_able_to(:read, client) }
  end

  context 'when user is a client' do
    let(:user) { create(:user) }
    let(:booked_session) { create(:session) }
    let(:other_session) { create(:session) }
    let(:coach) { create(:user) }
    
    before do
      user.roles << create(:role, name: 'client')
      booked_session.users << user
      coach.roles << create(:role, name: 'coach')
      booked_session.users << coach
    end

    it { is_expected.to be_able_to(:read, booked_session) }
    it { is_expected.not_to be_able_to(:manage, other_session) }
    it { is_expected.to be_able_to(:book, Session) }
    it { is_expected.to be_able_to(:read, coach) }
  end

  context 'when user is not authenticated' do
    let(:user) { nil }
    let(:session) { create(:session) }

    it { is_expected.not_to be_able_to(:manage, session) }
    it { is_expected.not_to be_able_to(:read, session) }
  end
end
