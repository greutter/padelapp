require "application_system_test_case"

class CourtsTest < ApplicationSystemTestCase
  setup do
    @court = courts(:one)
  end

  test "visiting the index" do
    visit courts_url
    assert_selector "h1", text: "Courts"
  end

  test "should create court" do
    visit courts_url
    click_on "New court"

    click_on "Create Court"

    assert_text "Court was successfully created"
    click_on "Back"
  end

  test "should update Court" do
    visit court_url(@court)
    click_on "Edit this court", match: :first

    click_on "Update Court"

    assert_text "Court was successfully updated"
    click_on "Back"
  end

  test "should destroy Court" do
    visit court_url(@court)
    click_on "Destroy this court", match: :first

    assert_text "Court was successfully destroyed"
  end
end
