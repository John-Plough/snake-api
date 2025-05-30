require_relative "boot"

require "rails/all"

# Load dotenv before other configuration
require "dotenv"
Dotenv.load

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SnakeApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 8.0

    # Enable cookie middleware
    config.middleware.use ActionDispatch::Cookies
    config.session_store :cookie_store, key: "_snake_api_session", same_site: :none, secure: true
    config.middleware.use ActionDispatch::Session::CookieStore, config.session_options

    # Configure CORS
    config.action_controller.allow_forgery_protection = false

    # Configure cookie settings
    # config.action_dispatch.cookies_same_site_protection = :lax

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
