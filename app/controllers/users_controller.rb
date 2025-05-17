class UsersController < ApplicationController
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      render json: {
        user: {
          id: @user.id,
          email: @user.email,
          username: @user.username
        }
      }, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end


  private

  def user_params
    params.permit(:username, :email, :password, :password_confirmation)
  end
end
