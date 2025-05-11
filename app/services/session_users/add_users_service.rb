module SessionUsers
  class AddUsersService
    def initialize(session:, user_ids:)
      @session = session
      @user_ids = Array(user_ids)
    end

    def call
      users = User.where(id: @user_ids)

      users.each do |user|
        @session.users << user unless @session.users.include?(user)
        user.add_role(:client) unless user.has_role?(:client)
      end

      users
    end
  end
end
