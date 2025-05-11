module Sessions
  class CreateService
    def self.call(params)
      Session.create!(params)
    end
  end
end
