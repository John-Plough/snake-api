require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  ApplicationController::JWT_SECRET = Rails.application.credentials.secret_key_base || "dev_secret_key"

  test "login" do
    # First create a user
    post "/users", params: {
      username: "Test",
      email: "test@test.com",
      password: "password",
      password_confirmation: "password"
    }, headers: { "X-CSRF-Token" => get_csrf_token }

    # Then try to login
    post "/login", params: { email: "test@test.com", password: "password" }, headers: { "X-CSRF-Token" => get_csrf_token }
    assert_response 201

    data = JSON.parse(response.body)
    assert_equal [ "user" ], data.keys
    assert_equal [ "id", "email", "username" ], data["user"].keys
  end

  test "logout" do
    # First create and login a user
    post "/users", params: {
      username: "Test",
      email: "test@test.com",
      password: "password",
      password_confirmation: "password"
    }, headers: { "X-CSRF-Token" => get_csrf_token }

    post "/login", params: { email: "test@test.com", password: "password" }, headers: { "X-CSRF-Token" => get_csrf_token }

    # Now try to logout
    delete "/logout", headers: { "X-CSRF-Token" => get_csrf_token }
    assert_response 200
  end

  private

  def get_csrf_token
    get "/"
    cookies["CSRF-TOKEN"]
  end
end
