# Be sure to restart your server when you modify this file.

# Avoid CORS issues when API is called from the frontend app.
# Handle Cross-Origin Resource Sharing (CORS) in order to accept cross-origin Ajax requests.

# Read more: https://github.com/cyu/rack-cors

# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'  # Allows requests from all origins. You can specify specific domains if needed.

    resource '*',  # Allows any resource (endpoint) in your API
      headers: :any,  # Accepts any headers
      methods: [:get, :post, :put, :patch, :delete, :options, :head]  # Allows these HTTP methods
  end
end

