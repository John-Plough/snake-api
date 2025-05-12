require "test_helper"

class ScoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      username: "testuser",
      email: "test@example.com",
      password: "password",
      password_confirmation: "password"
    )

    payload = { user_id: @user.id }
    @token = JWT.encode(payload, ApplicationController::JWT_SECRET, "HS256")
  end

  test "index" do
    get "/scores.json"
    assert_response :success

    data = JSON.parse(response.body)
    assert_equal Score.count, data.length
  end

  test "create" do
    assert_difference "Score.count", 1 do
      post "/scores.json",
           params: { value: 10 },
           headers: { "Authorization" => "Bearer #{@token}" }
      assert_response :success
    end
  end

  test "should create score with json format" do
    post "/scores.json",
         params: { value: 100 }.to_json,
         headers: {
           "Authorization" => "Bearer #{@token}",
           "Content-Type" => "application/json"
         }
    assert_response :success
  end
end
