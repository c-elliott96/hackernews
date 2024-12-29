require "test_helper"

class SubmitControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get submit_index_url
    assert_response :success
  end
end
