Rails.application.config.middleware.use OmniAuth::Builder do
  # Debug logging
  Rails.logger.debug "GOOGLE_CLIENT_ID: #{ENV['GOOGLE_CLIENT_ID']}"
  Rails.logger.debug "GOOGLE_CLIENT_SECRET: #{ENV['GOOGLE_CLIENT_SECRET']}"

  provider :github, ENV["GITHUB_CLIENT_ID"], ENV["GITHUB_CLIENT_SECRET"],
    scope: "user:email",
    callback_path: "/auth/github/callback"

  provider :google_oauth2, ENV["GOOGLE_CLIENT_ID"], ENV["GOOGLE_CLIENT_SECRET"],
    scope: "email profile",
    callback_path: "/auth/google_oauth2/callback",
    prompt: "select_account"
end

# For development, allow GET requests
OmniAuth.config.allowed_request_methods = [ :get, :post ]
OmniAuth.config.silence_get_warning = true
