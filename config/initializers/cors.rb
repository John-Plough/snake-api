# config/initializers/cors.rb
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "localhost:5173", "localhost:3000", "honeymaker.onrender.com", "snake.onrender.com"
    resource "*",
             headers: :any,
             methods: [ :get, :post, :put, :patch, :delete, :options, :head ],
             credentials: true,
             expose: [ "Authorization" ]
  end
end
