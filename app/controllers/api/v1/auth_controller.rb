module Api
  module V1
    class AuthController < BaseController
      skip_before_action :authenticate_user!

      def signup
        user = Auth::SignupService.call(signup_params)
        render json: user, serializer: UserSerializer, status: :created
      rescue StandardError => e
        render json: { error: e.message }, status: :unprocessable_entity
      end

      def login
        token, user = Auth::LoginService.call(login_params)
        render json: { token: token, user: user }, status: :ok
      rescue StandardError => e
        render json: { error: e.message }, status: :unauthorized
      end

      def forgot_password
        Auth::ForgotPasswordService.call(params[:email])
        render json: { message: 'Reset link sent' }, status: :ok
      end

      def reset_password
        Auth::ResetPasswordService.call(params[:token], params[:password])
        render json: { message: 'Password updated' }, status: :ok
      end

      def logout
        Auth::LogoutService.call(current_user) if current_user
        render json: { message: 'Logged out successfully' }, status: :ok
      end

      private

      def signup_params
        params.permit(:name, :email, :password, :role)
      end

      def login_params
        params.permit(:email, :password)
      end
    end
  end
end
