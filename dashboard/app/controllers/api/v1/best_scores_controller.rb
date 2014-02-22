module Api::V1
class BestScoresController < ApplicationController
  before_filter :set_leaderboard

  # Note:
  # The overriden method User#as_json does not get called when ':include => :user'
  # is passed to Score#as_json.
  def index
    x = params.delete(:page_num)
    y = params.delete(:num_per_page)
    @scores = score_class.bests_1_0(@leaderboard.id, {page_num: x, num_per_page: y})
    ActiveRecord::Associations::Preloader.new(@scores, [:user]).run
    render json: @scores
  end

  def user
    @score = score_class.best_1_0(@leaderboard.id, params[:user_id])
    ActiveRecord::Associations::Preloader.new(@score, [:user]).run
    render json: @score
  end
  
  def user_multiple
    @scores = []
    @leaderboards.each do |leaderboard|
      score = score_class.best_1_0(leaderboard.id, params[:user_id])
      ActiveRecord::Associations::Preloader.new(score, [:user]).run
      @scores << score
    end
    render json: @scores
  end

  def social
    @scores = params[:fb_friends] && score_class.social(authorized_app, @leaderboard, params[:fb_friends]) || []
    render json: @scores
  end

  private
  def set_leaderboard
    leaderboard_ids = params.delete(:leaderboard_id)
    if leaderboard_ids.is_a? String
      leaderboard_ids = leaderboard_ids.split(",")
    end
    @leaderboards = authorized_app.leaderboards.where(id: leaderboard_ids).to_a
    @leaderboard = @leaderboards.first
    unless @leaderboard
      render status: :forbidden, json: {message: "Pass a leaderboard_id that belongs to the app associated with app_key"}
    end
  end
  
  def score_class
    @score_class ||= in_sandbox? ? SandboxScore : Score
  end
end
end