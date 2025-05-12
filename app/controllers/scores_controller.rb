class ScoresController < ApplicationController
  def index
    @scores = Score.all
    render :index
  end
end
