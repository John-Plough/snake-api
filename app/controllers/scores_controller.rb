class ScoresController < ApplicationController
  def index
    @scores = Score.all
    render :index
  end

  def create
    @score = Score.create(
      value: params[:value],
      user_id: params[:user_id]
    )
    render :show
  end

  def user_scores
    user = User.find_by(id: params[:user_id])

    if user
      scores = user.scores.order(created_at: :desc)
      render json: scores
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end
end
