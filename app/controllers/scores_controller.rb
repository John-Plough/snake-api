class ScoresController < ApplicationController
  include ActionController::Cookies
  before_action :authenticate_user, except: [ :global ]

  def index
    scores = Score.includes(:user).order(value: :desc).limit(10)
    render json: scores
  end

  def create
    score = @current_user.scores.create!(score_params)
    render json: score, status: :created
  end

  def personal
    scores = @current_user.scores
                        .order(value: :desc)
                        .limit(6)
                        .select("scores.*, users.username")
                        .joins(:user)
    render json: scores
  end

  def global
    scores = Score.order(value: :desc)
                 .limit(6)
                 .select("scores.*, users.username")
                 .joins(:user)
    render json: scores
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

  private

  def score_params
    params.require(:score).permit(:value)
  end
end
