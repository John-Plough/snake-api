Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  post "/users" => "users#create"

  post "/scores" => "scores#create"
  get "/scores" => "scores#index"
  get "/users/:user_id/scores", to: "scores#user_scores"
end
