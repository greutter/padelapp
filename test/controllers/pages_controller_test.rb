require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "root should get home" do
    get root_url
    assert_response :success
  end

  # test "should have a registration link" do
  #   get root_url
  #   assert_select "a", text: "Crear Cuenta"
  # end

  test "should have a sign-in link" do
    get root_url
    assert_select "a", text: "Iniciar Sesión"
  end

end
