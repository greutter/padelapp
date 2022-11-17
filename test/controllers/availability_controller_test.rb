require "test_helper"

class AvailabilityControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get availability_index_url
    assert_response :success
  end
end
