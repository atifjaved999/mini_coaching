module Api
  module V1
    class SessionUsersController < BaseController
      skip_before_action :authenticate_user!
      before_action :set_session
      before_action :set_user, only: [:destroy]

      # GET /api/v1/sessions/:session_id/session_users
      def index
        render json: {
          success: true,
          data: {
            coaches: ActiveModelSerializers::SerializableResource.new(@session.coaches, each_serializer: UserSerializer),
            clients: ActiveModelSerializers::SerializableResource.new(@session.clients, each_serializer: UserSerializer)
          }
        }, status: :ok
      end

      # POST /api/v1/sessions/:session_id/session_users
      def create
        users = ::SessionUsers::AddUsersService.new(session: @session, user_ids: params[:user_ids]).call

        render json: {
          success: true,
          message: "#{users.size} user(s) added to session"
        }, status: :ok
      end

      # DELETE /api/v1/sessions/:session_id/session_users/:id
      def destroy
        ::SessionUsers::RemoveUserService.new(session: @session, user: @user).call

        render json: {
          success: true,
          message: "User removed from session"
        }, status: :ok
      end

      private

      def set_session
        @session = Session.find(params[:session_id])
      end

      def set_user
        @user = User.find(params[:id])
      end
    end
  end
end
