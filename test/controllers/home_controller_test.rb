require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get home_index_url
    assert_response :success
  end

  test "should get index_auth" do
    get home_index_auth_url
    assert_response :success
  end
end
