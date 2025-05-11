module Api
  module V1
    class BaseController < ApplicationController
      before_action :authenticate_user!

      attr_reader :current_user

      private

      def authenticate_user!
        token = request.headers['Authorization']&.split(' ')&.last
        decoded = JwtToken.decode(token)
        @current_user = User.find_by(id: decoded["user_id"]) if decoded
        render json: { success: false, error: 'Unauthorized' }, status: :unauthorized unless @current_user
      end
    end
  end
end
