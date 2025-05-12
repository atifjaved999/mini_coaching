Rails.application.config.active_job.queue_adapter = :sidekiq

# Configure queue names for different job types
Rails.application.config.action_mailer.deliver_later_queue_name = :mailers
