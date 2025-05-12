class SessionsController < ApplicationController
  JWT.encode(payload, jwt_secret, "HS256")

  def authenticate_user
    header = request.headers["Authorization"]
    token = header.split(" ").last rescue nil

    begin
      decoded = JWT.decode(token, JWT_SECRET, true, { algorithm: "HS256" })
      @current_user = User.find(decoded[0]["user_id"])
    rescue
      render json: { error: "Unauthorized" }, status: :unauthorized
    end
  end
end
