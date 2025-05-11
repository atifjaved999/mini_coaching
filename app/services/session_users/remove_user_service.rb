module SessionUsers
  class RemoveUserService
    def initialize(session:, user:)
      @session = session
      @user = user
    end

    def call
      @session.users.delete(@user)
    end
  end
end
