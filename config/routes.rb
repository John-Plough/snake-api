Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  post "/users" => "users#create"
  post "/login" => "sessions#create"
  delete "/logout" => "sessions#destroy"

  # Score routes
  resources :scores, only: [ :index, :show, :create, :update, :destroy ] do
    collection do
      get "personal"
      get "global"
    end
  end
  get "/users/:user_id/scores" => "scores#user_scores"

  # OAuth routes
  get "/auth/:provider/callback", to: "auth#oauth_callback"
  post "/auth/:provider", to: "auth#oauth"
  get "/auth/check", to: "auth#check"

  if Rails.env.production?
    get "/run_migrations", to: "application#run_migrations"
  end
end
