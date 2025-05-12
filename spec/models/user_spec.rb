require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe 'associations' do
    it { should have_many(:session_users) }
    it { should have_many(:sessions).through(:session_users) }
  end

  describe 'validations' do
    it { should have_secure_password }
  end

  describe '#generate_token' do
    it 'generates a JWT token with user_id' do
      user.save
      token = user.generate_token
      puts "Generated token: #{token}"
      decoded_token = JwtToken.decode(token)
      puts "Decoded token: #{decoded_token.inspect}"
      expect(decoded_token['user_id']).to eq(user.id)
    end
  end

  describe '.decode_token' do
    it 'returns user from valid token' do
      user.save
      token = user.generate_token
      puts "Generated token: #{token}"
      decoded_token = JwtToken.decode(token)
      puts "Decoded token: #{decoded_token.inspect}"
      decoded_user = User.decode_token(token)
      expect(decoded_user).to eq(user)
    end

    it 'returns nil for invalid token' do
      expect(User.decode_token('invalid_token')).to be_nil
    end
  end

  describe 'roles' do
    it 'can be assigned a coach role' do
      user.add_role(:coach)
      expect(user.has_role?(:coach)).to be true
    end

    it 'can be assigned a client role' do
      user.add_role(:client)
      expect(user.has_role?(:client)).to be true
    end
  end
end
