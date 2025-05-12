# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      payload = { user_id: user.id }
      token   = JWT.encode(payload, ApplicationController::JWT_SECRET, "HS256")

      # Don’t render :show here — send a custom JSON response
      render json: { token: token, user: { id: user.id, email: user.email } }, status: :created
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def destroy
    render json: { message: "Logged out" }, status: :ok
  end
end
