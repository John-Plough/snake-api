require "test_helper"

class ScoresControllerTest < ActionDispatch::IntegrationTest
  test "index" do
    get "/scores.json"
    assert_response 200

    data = JSON.parse(response.body)
    assert_equal Score.count, data.length
  end

test "create" do
  user = User.create!(
    username: "testuser",
    email: "test@example.com",
    password: "secret",
    password_confirmation: "secret"
  )

  assert_difference "Score.count", 1 do
    post "/scores.json", params: { value: 10, user_id: user.id }
    assert_response :success
  end
end
end
