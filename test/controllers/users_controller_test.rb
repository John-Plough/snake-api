require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    # Get CSRF token
    get "/"
    @csrf_token = cookies["CSRF-TOKEN"]
  end

  test "create" do
    assert_difference "User.count", 1 do
      post "/users",
           params: { username: "smoky74", email: "lake@example.com", password: "secret", password_confirmation: "secret" },
           headers: { "X-CSRF-Token" => @csrf_token }
      assert_response 201
    end
  end
end
