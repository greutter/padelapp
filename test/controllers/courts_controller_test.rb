require "test_helper"

class CourtsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @court = courts(:one)
  end

  test "should get index" do
    get courts_url
    assert_response :success
  end

  test "should get new" do
    get new_court_url
    assert_response :success
  end

  test "should create court" do
    assert_difference("Court.count") do
      post courts_url, params: { court: {  } }
    end

    assert_redirected_to court_url(Court.last)
  end

  test "should show court" do
    get court_url(@court)
    assert_response :success
  end

  test "should get edit" do
    get edit_court_url(@court)
    assert_response :success
  end

  test "should update court" do
    patch court_url(@court), params: { court: {  } }
    assert_redirected_to court_url(@court)
  end

  test "should destroy court" do
    assert_difference("Court.count", -1) do
      delete court_url(@court)
    end

    assert_redirected_to courts_url
  end
end
