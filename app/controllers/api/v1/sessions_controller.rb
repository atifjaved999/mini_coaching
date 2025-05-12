module Api
  module V1
    class SessionsController < BaseController
      load_and_authorize_resource except: [:client_sessions, :coach_sessions, :book]
      before_action :set_session, only: [:show, :update, :destroy]

      def client_sessions
        sessions = Session.joins(:users)
                          .where(users: { id: current_user.id })
                          .merge(User.with_role(:client))
                          .distinct

        render json: sessions, each_serializer: SessionSerializer, status: :ok
      end

      def coach_sessions
        sessions = Session.joins(:users)
                          .where(users: { id: current_user.id })
                          .merge(User.with_role(:coach))
                          .distinct

        render json: sessions, each_serializer: SessionSerializer, status: :ok
      end

      def index
        sessions = Cache::SessionCacheService.fetch_sessions
        render json: sessions, each_serializer: SessionSerializer, status: :ok
      end

      def show
        render json: @session, serializer: SessionSerializer, status: :ok
      end

      def create
        session = Sessions::CreateService.call(session_params)
        render json: session, serializer: SessionSerializer, status: :created
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      def book
        session = Sessions::BookService.call(
          current_user: current_user,
          coach_id: params[:coach_id],
          scheduled_at: params[:scheduled_at]
        )

        render json: session, serializer: SessionSerializer, status: :ok
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      def update
        session = Sessions::UpdateService.call(@session, session_params)
        render json: session, serializer: SessionSerializer, status: :ok
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      def destroy
        Sessions::DestroyService.call(@session)
        render json: { message: 'Session deleted successfully' }, status: :ok
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      def available
        sessions = Session.includes(:users)
                          .where(scheduled_at: params[:date])
                          .where('start_time >= ? AND end_time <= ?', params[:start_time], params[:end_time])
                          .select { |s| s.coaches.any? }

        render json: sessions, each_serializer: SessionSerializer
      end

      private

      def set_session
        @session = Sessions::FetchService.find(params[:id])
      end

      def session_params
        permitted = params.permit(:title, :description, :scheduled_at, :start_time, :end_time)

        if params[:user_ids].present?
          permitted[:user_ids] = params[:user_ids].is_a?(String) ? JSON.parse(params[:user_ids]) : params[:user_ids]
        end

        permitted
      end

      def authorize_coach
        unless current_user.has_role?(:coach)
          render json: { error: "You are not authorized to perform this action." }, status: :forbidden
        end
      end
    end
  end
end
