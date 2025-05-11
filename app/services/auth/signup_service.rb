module Auth
  class SignupService
    VALID_ROLES = %w[coach client].freeze

    def self.call(params)
      role = params.delete(:role)
      user = User.new(params)

      raise StandardError, user.errors.full_messages.to_sentence unless user.save

      user.add_role(role) if role.present? && VALID_ROLES.include?(role)

      user
    end
  end
end
