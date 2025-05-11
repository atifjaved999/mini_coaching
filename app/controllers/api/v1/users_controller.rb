module Api
  module V1
    class UsersController < BaseController
      def index
        users = User.order(created_at: :desc)
        render json: users, each_serializer: UserSerializer, status: :ok
      end
    end
  end
end
