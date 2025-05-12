Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  post "/users" => "users#create"

  get "/scores" => "scores#index"
end
