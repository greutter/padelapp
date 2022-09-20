require "application_system_test_case"

class HomeTest < ApplicationSystemTestCase
  setup do
    visit root_url
  end

  test "visiting home.html" do
    assert_selector "h2", text: "Padel"
  end

  test "should show avilabel courts for today" do
    assert_selector "a", text: "Hoy"
    assert_selector "a", id: Date.today.strftime('%Y-%m-%d')
  end

end
