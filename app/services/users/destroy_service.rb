module Users
  class DestroyService
    def self.call(user)
      user.destroy!
    end
  end
end
