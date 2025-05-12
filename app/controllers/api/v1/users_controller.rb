module Api
  module V1
    class UsersController < BaseController
      before_action :authenticate_user!
      before_action :set_user, only: [:update, :destroy]

      def index
        users = if params[:role].present?
                  User.with_role(params[:role]).order(created_at: :desc)
                else
                  User.order(created_at: :desc)
                end

        render json: users, each_serializer: UserSerializer, status: :ok
      end

      def update
        user = Users::UpdateService.call(@user, user_params, params[:roles])
        render json: user, serializer: UserSerializer, status: :ok
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      def destroy
        Users::DestroyService.call(@user)
        render json: { message: "User deleted successfully" }, status: :ok
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.permit(:name, :email, :password)
      end
    end
  end
end
