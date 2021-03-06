require 'test_helper'

class AchievementsApiTest < ActionDispatch::IntegrationTest

  def setup
    @game = FactoryGirl.create(:app)
    OpenKit::Config.app_key    = @game.app_key
    OpenKit::Config.secret_key = @game.secret_key
  end


  test "an empty achievement list" do
    get '/achievements'
    assert response.success?
    assert_equal '[]', response.body
  end


  test "achievement list with one achievement" do
    achievement = FactoryGirl.create(:achievement, :app => @game)
    get '/achievements'
    assert response.success?
    achievements_json = JSON.parse(response.body)
    assert_equal achievement.id, achievements_json[0]['id']
  end


  test "user progress returned in list of achievements if user_id included in GET" do
    achievement = create(:achievement, :app => @game, :goal => 4)
    user = create_subscribed_user_for(@game)

    get "/achievements"
    a1 = JSON.parse(response.body).first
    refute a1.keys.include? 'progress'

    get "/achievements?user_id=#{user.id}"
    a2 = JSON.parse(response.body).first
    assert a2.keys.include? 'progress'
    assert_equal 0, a2['progress']

    create(:achievement_score, :achievement => achievement, :user => user, :progress => 1)
    get "/achievements?user_id=#{user.id}"
    a3 = JSON.parse(response.body).first
    assert a3.keys.include? 'progress'
    assert_equal 1, a3['progress']
  end
end
