require "test_helper"

class NewControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get new_index_url
    assert_response :success
  end
end
