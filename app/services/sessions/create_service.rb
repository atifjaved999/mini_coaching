module Sessions
  class CreateService
    def self.call(params)
      user_ids = params.delete(:user_ids)

      session = Session.create!(params)

      if user_ids.present?
        users = User.where(id: user_ids)
        session.users << users
      end

      session
    end
  end
end
