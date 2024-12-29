require "test_helper"

class ShowControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get show_index_url
    assert_response :success
  end

  test "should get show" do
    get show_show_url
    assert_response :success
  end
end
