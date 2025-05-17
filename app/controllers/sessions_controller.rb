# app/controllers/sessions_controller.rb
class SessionsController < ApplicationController
  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
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
    session.delete(:user_id)
    render json: { message: "Logged out" }, status: :ok
  end
end
