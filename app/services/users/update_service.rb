module Users
  class UpdateService
    def self.call(user, attributes, roles)
      user.assign_attributes(attributes)

      ActiveRecord::Base.transaction do
        user.save!
        if roles.present?
          user.roles = [] # clear existing roles
          user.add_role(roles)
        end
      end

      user
    end
  end
end
