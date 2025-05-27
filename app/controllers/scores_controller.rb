class ScoresController < ApplicationController
  include ActionController::Cookies
  before_action :authenticate_user, except: [ :index, :global ]

  def index
    @scores = Score.includes(:user).order(value: :desc).limit(10)
    render :index
  end

  def create
    @score = @current_user.scores.build(score_params)
    if @score.save
      render json: {
        id: @score.id,
        value: @score.value,
        created_at: @score.created_at,
        user: {
          id: @current_user.id,
          username: @current_user.username
        }
      }, status: :created
    else
      render json: { errors: @score.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    @score = Score.find_by(id: params[:id])
    if @score
      render :show
    else
      render json: { error: "Score not found" }, status: :not_found
    end
  end

  def update
    @score = @current_user.scores.find_by(id: params[:id])
    if @score
      if @score.update(score_params)
        render :show
      else
        render json: { errors: @score.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: "Score not found" }, status: :not_found
    end
  end

  def destroy
    @score = @current_user.scores.find_by(id: params[:id])
    if @score
      @score.destroy
      render json: { message: "Score deleted successfully" }
    else
      render json: { error: "Score not found" }, status: :not_found
    end
  end

  def personal
    @scores = @current_user.scores
                         .includes(:user)
                         .order(value: :desc)
                         .limit(6)
    render :index
  end

  def global
    @scores = Score.includes(:user)
                  .order(value: :desc)
                  .limit(6)
    render :index
  end

  def user_scores
    user = User.find_by(id: params[:user_id])
    if user
      @scores = user.scores.order(created_at: :desc)
      render :index
    else
      render json: { error: "User not found" }, status: :not_found
    end
  end

  private

  def score_params
    params.require(:score).permit(:value)
  end
end
