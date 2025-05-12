require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  ApplicationController::JWT_SECRET = Rails.application.credentials.secret_key_base || "dev_secret_key"

  test "login" do
    post "/users.json", params: {
      username: "Test",
      email: "test@test.com",
      password: "password",
      password_confirmation: "password"
    }

    post "/login.json", params: { email: "test@test.com", password: "password" }
    assert_response 201

    data = JSON.parse(response.body)
    assert_equal [ "token", "user" ], data.keys
  end

  test "logout" do
    delete "/logout.json"
    assert_response 200
  end
end
