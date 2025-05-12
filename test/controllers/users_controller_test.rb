require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "create" do
    assert_difference "User.count", 1 do
      post "/users.json", params: { username: "smoky74", email: "lake@example.com", password: "secret", password_confirmation: "secret" }
      assert_response 201
    end
  end
end
