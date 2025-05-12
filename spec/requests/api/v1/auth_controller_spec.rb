require 'rails_helper'

RSpec.describe Api::V1::AuthController, type: :request do
  let(:user) { create(:user) }
  let(:token) { user.generate_token }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  describe 'POST /api/v1/auth/signup' do
    let(:valid_params) do
      {
        name: 'Test User',
        email: 'test@example.com',
        password: 'password123',
        role: 'client'
      }
    end

    it 'creates a new user' do
      expect {
        post '/api/v1/auth/signup', params: valid_params
      }.to change(User, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it 'returns error for invalid params' do
      post '/api/v1/auth/signup', params: { email: '' }
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'POST /api/v1/auth/login' do
    let(:login_params) do
      {
        email: user.email,
        password: 'password123'
      }
    end

    before do
      user.update(password: 'password123')
    end

    it 'returns token for valid credentials' do
      post '/api/v1/auth/login', params: login_params
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['token']).to be_present
    end

    it 'returns error for invalid credentials' do
      post '/api/v1/auth/login', params: { email: user.email, password: 'wrong' }
      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'POST /api/v1/auth/forgot_password' do
    it 'sends reset password instructions' do
      post '/api/v1/auth/forgot_password', params: { email: user.email }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /api/v1/auth/reset_password' do
    let(:reset_token) { user.generate_token }
    let(:new_password) { 'new_password123' }

    it 'resets password with valid token' do
      allow(Auth::ResetPasswordService).to receive(:call).with(reset_token, new_password).and_return(true)
      post '/api/v1/auth/reset_password',
           params: { token: reset_token, password: new_password }
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'DELETE /api/v1/auth/logout' do
    it 'logs out the user' do
      delete '/api/v1/auth/logout', headers: headers
      expect(response).to have_http_status(:ok)
    end
  end
end
