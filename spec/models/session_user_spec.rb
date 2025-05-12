require 'rails_helper'

RSpec.describe SessionUser, type: :model do
  let(:session_user) { build(:session_user) }

  describe 'associations' do
    it { should belong_to(:session) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it 'is valid with valid attributes' do
      expect(session_user).to be_valid
    end

    it 'is not valid without a session' do
      session_user.session = nil
      expect(session_user).not_to be_valid
    end

    it 'is not valid without a user' do
      session_user.user = nil
      expect(session_user).not_to be_valid
    end
  end
end
