Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  post "/users" => "users#create"
  post "/login" => "sessions#create"
  delete "/logout" => "sessions#destroy"

  # Score routes - specific before general
  get "/scores/personal" => "scores#personal"
  get "/scores/global" => "scores#global"
  get "/users/:user_id/scores" => "scores#user_scores"
  get "/scores" => "scores#index"
  post "/scores" => "scores#create"
end
