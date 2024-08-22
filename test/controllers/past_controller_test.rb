require "test_helper"

class PastControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get past_index_url
    assert_response :success
  end
end
