require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :request do
  let(:user) { create(:user) }
  let(:token) { user.generate_token }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }

  describe 'GET /api/v1/users' do
    before do
      create_list(:user, 3)
      user.add_role(:coach)
    end

    it 'returns all users' do
      get '/api/v1/users', headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(4) # 3 created users + 1 coach user
    end

    it 'returns users with specific role' do
      get '/api/v1/users', params: { role: 'coach' }, headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end

  describe 'PUT /api/v1/users/:id' do
    let(:update_params) { { name: 'Updated Name' } }

    it 'updates the user' do
      put "/api/v1/users/#{user.id}", params: update_params, headers: headers
      expect(response).to have_http_status(:ok)
      expect(user.reload.name).to eq('Updated Name')
    end
  end

  describe 'DELETE /api/v1/users/:id' do
    it 'deletes the user' do
      delete "/api/v1/users/#{user.id}", headers: headers
      expect(response).to have_http_status(:ok)
      expect(User.find_by(id: user.id)).to be_nil
    end
  end
end
