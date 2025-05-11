module Api
  module V1
    class SessionsController < BaseController
      before_action :set_session, only: [:show, :update, :destroy]
      before_action :authorize_coach, only: [:create, :update, :destroy]

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
        sessions = Sessions::FetchService.all
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

      def update
        session = Sessions::UpdateService.call(@session, session_params)
        render json: session, serializer: SessionSerializer, status: :ok
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      def destroy
        Sessions::DestroyService.call(@session)
        head :no_content
      end

      private

      def set_session
        @session = Sessions::FetchService.find(params[:id])
      end

      def session_params
        params.require(:session).permit(:title, :description, :scheduled_at, :start_time, :end_time)
      end

      def authorize_coach
        unless current_user.has_role?(:coach)
          render json: { error: "You are not authorized to perform this action." }, status: :forbidden
        end
      end
    end
  end
end
