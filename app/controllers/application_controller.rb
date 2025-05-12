class ApplicationController < ActionController::Base
   JWT_SECRET = Rails.application.credentials.secret_key_base || "dev_secret_key"

   def authenticate_user
    header = request.headers["Authorization"]
    token = header.split(" ").last rescue nil

    begin
      decoded = JWT.decode(token, JWT_SECRET, true, algorithm: "HS256")
      @current_user = User.find(decoded[0]["user_id"])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end

  allow_browser versions: :modern
  protect_from_forgery with: :exception, unless: -> { request.format.json? }
end
