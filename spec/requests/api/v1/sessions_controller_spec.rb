require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :request do
  let(:user) { create(:user) }
  let(:token) { user.generate_token }
  let(:headers) { { 'Authorization' => "Bearer #{token}" } }
  let(:coach) { create(:user) }
  let(:client) { create(:user) }

  before do
    coach.add_role(:coach)
    client.add_role(:client)
    user.add_role(:coach)
  end

  describe 'GET /api/v1/sessions' do
    let(:sessions) { create_list(:session, 3) }

    it 'returns all sessions' do
      allow(Sessions::FetchService).to receive(:all).and_return(sessions)
      get '/api/v1/sessions', headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(3)
    end
  end

  describe 'GET /api/v1/sessions/:id' do
    let(:session) { create(:session) }

    before do
      session.users << user  # Associate the session with the coach
    end

    it 'returns the session' do
      get "/api/v1/sessions/#{session.id}", headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(session.id)
    end

    context 'when user is not associated with the session' do
      let(:other_session) { create(:session) }

      it 'returns forbidden' do
        get "/api/v1/sessions/#{other_session.id}", headers: headers
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'POST /api/v1/sessions' do
    let(:valid_params) do
      {
        title: 'Test Session',
        description: 'Test Description',
        scheduled_at: Date.today,
        start_time: '10:00',
        end_time: '11:00',
        user_ids: [coach.id, client.id]
      }
    end

    it 'creates a new session' do
      session = build(:session)
      allow(Sessions::CreateService).to receive(:call) do |params|
        expect(params).to be_a(ActionController::Parameters)
        expect(params).to be_permitted
        session
      end
      post '/api/v1/sessions', params: valid_params, headers: headers
      expect(response).to have_http_status(:created)
    end

    it 'returns error for invalid params' do
      allow(Sessions::CreateService).to receive(:call).and_raise(StandardError.new('Invalid params'))
      post '/api/v1/sessions', params: {}, headers: headers
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'PUT /api/v1/sessions/:id' do
    let(:session) { create(:session) }
    let(:update_params) { { title: 'Updated Title' } }

    before do
      session.users << user  # Associate the session with the coach
    end

    it 'updates the session' do
      put "/api/v1/sessions/#{session.id}", params: update_params, headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['title']).to eq('Updated Title')
    end

    context 'when user is not associated with the session' do
      let(:other_session) { create(:session) }

      it 'returns forbidden' do
        put "/api/v1/sessions/#{other_session.id}", params: update_params, headers: headers
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'DELETE /api/v1/sessions/:id' do
    let(:session) { create(:session) }

    before do
      session.users << user  # Associate the session with the coach
    end

    it 'deletes the session' do
      delete "/api/v1/sessions/#{session.id}", headers: headers
      expect(response).to have_http_status(:ok)
    end

    context 'when user is not associated with the session' do
      let(:other_session) { create(:session) }

      it 'returns forbidden' do
        delete "/api/v1/sessions/#{other_session.id}", headers: headers
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe 'GET /api/v1/client_sessions' do
    let(:session) { create(:session) }
    before { session.users << client }

    it 'returns sessions where user is a client' do
      allow(Session).to receive_message_chain(:joins, :where, :merge, :distinct).and_return([session])
      get '/api/v1/client_sessions', headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end

  describe 'GET /api/v1/coach_sessions' do
    let(:session) { create(:session) }
    before { session.users << coach }

    it 'returns sessions where user is a coach' do
      allow(Session).to receive_message_chain(:joins, :where, :merge, :distinct).and_return([session])
      get '/api/v1/coach_sessions', headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end

  describe 'POST /api/v1/sessions/book' do
    let(:booking_params) do
      {
        coach_id: coach.id,
        scheduled_at: Date.today
      }
    end

    it 'books a session with a coach' do
      session = build(:session)
      allow(Sessions::BookService).to receive(:call).with(
        current_user: user,
        coach_id: coach.id.to_s,
        scheduled_at: Date.today.to_s
      ).and_return(session)
      post '/api/v1/sessions/book', params: booking_params, headers: headers
      expect(response).to have_http_status(:ok)
    end
  end
end
