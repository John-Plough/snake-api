class ScoresController < ApplicationController
  before_action :authenticate_user, only: [ :create ]
  def index
    @scores = Score.includes(:user).order(value: :desc).limit(10)
    render :index
  end

  def create
    @score = @current_user.scores.create(value: params[:value])

    if @score.persisted?
      render :show, status: :created
    else
      render json: { errors: @score.errors.full_messages }, status: :unprocessable_entity
    end
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
