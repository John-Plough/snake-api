require "test_helper"

class ScoresControllerTest < ActionDispatch::IntegrationTest
  test "index" do
    get "/scores.json"
    assert_response 200

    data = JSON.parse(response.body)
    assert_equal Score.count, data.length
  end
end
