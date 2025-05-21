require "test_helper"

class ScoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(
      username: "testuser",
      email: "test@example.com",
      password: "password",
      password_confirmation: "password"
    )

    # Get CSRF token
    get "/"
    @csrf_token = cookies["CSRF-TOKEN"]

    # Login the user
    post "/login",
         params: { email: "test@example.com", password: "password" },
         headers: { "X-CSRF-Token" => @csrf_token }
  end

  test "index" do
    get "/scores", headers: { "X-CSRF-Token" => @csrf_token }
    assert_response :success

    data = JSON.parse(response.body)
    assert_equal Score.count, data.length
  end

  test "create" do
    assert_difference "Score.count", 1 do
      post "/scores",
           params: { score: { value: 10 } },
           headers: { "X-CSRF-Token" => @csrf_token }
      assert_response :success
    end
  end

  test "should create score with json format" do
    post "/scores",
         params: { score: { value: 100 } }.to_json,
         headers: {
           "Content-Type" => "application/json",
           "X-CSRF-Token" => @csrf_token
         }
    assert_response :success
  end
end
