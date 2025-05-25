# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  COOKIE_SETTINGS = { secure: true, same_site: "None", httponly: true }

  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      cookies.signed[:user_id] = { value: user.id }.merge(COOKIE_SETTINGS)
      render json: {
        user: {
          id: user.id,
          email: user.email,
          username: user.username
        }
      }, status: :created
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  def destroy
    cookies.delete(:user_id, COOKIE_SETTINGS)
    render json: { message: "Logged out" }, status: :ok
  end
end
