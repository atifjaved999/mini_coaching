module Sessions
  class FetchService
    def self.all
      Session.all.order(scheduled_at: :asc)
    end

    def self.find(id)
      Session.find(id)
    end
  end
end
