require 'rails_helper'

RSpec.describe Api::V1::SessionUsersController, type: :request do
  let(:user) { create(:user) }
  let(:token) { user.generate_token }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:session) { create(:session) }
  let(:new_user) { create(:user) }

  describe 'GET /api/v1/sessions/:session_id/session_users' do
    before do
      session.users << user
      user.add_role(:coach)
    end

    it 'returns session users grouped by role' do
      get "/api/v1/sessions/#{session.id}/session_users", headers: headers
      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['success']).to be true
      expect(json_response['data']['coaches']).to be_present
    end
  end

  describe 'POST /api/v1/sessions/:session_id/session_users' do
    let(:valid_params) { { user_ids: [new_user.id] } }

    it 'adds users to the session' do
      expect {
        post "/api/v1/sessions/#{session.id}/session_users",
             params: valid_params,
             headers: headers
      }.to change(SessionUser, :count).by(1)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'DELETE /api/v1/sessions/:session_id/session_users/:id' do
    before do
      session.users << new_user
    end

    it 'removes user from the session' do
      expect {
        delete "/api/v1/sessions/#{session.id}/session_users/#{new_user.id}",
               headers: headers
      }.to change(SessionUser, :count).by(-1)
      expect(response).to have_http_status(:ok)
    end
  end
end
