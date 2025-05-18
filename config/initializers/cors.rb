# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins ENV["CORS_ORIGINS"] || [
      "http://localhost:5173",                                    # Development
      "https://john-plough.github.io",                           # Production base domain
      "https://john-plough.github.io/honeymaker"                 # Production with path
    ]

    resource "*",
             headers: :any,
             methods: [ :get, :post, :put, :patch, :delete, :options, :head ],
             credentials: true,
             expose: [ "Authorization" ]
  end
end
