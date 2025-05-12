Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  post "/users" => "users#create"
  post "/login" => "sessions#create"
  delete "/logout" => "sessions#destroy"

  post "/scores" => "scores#create"
  get "/scores" => "scores#index"

  get "/users/:user_id/scores" => "scores#user_scores"
end
