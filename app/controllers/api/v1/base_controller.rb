module Api
  module V1
    class BaseController < ApplicationController
      include CanCan::ControllerAdditions

      before_action :authenticate_user!
      attr_reader :current_user

      rescue_from CanCan::AccessDenied do |exception|
        render json: { error: exception.message }, status: :forbidden
      end

      private

      def authenticate_user!
        token = request.headers['Authorization']&.split(' ')&.last
        @current_user = User.decode_token(token)
        render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
      end

      def current_ability
        @current_ability ||= Ability.new(current_user)
      end
    end
  end
end
