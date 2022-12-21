require "application_system_test_case"

class DeviseTest < ApplicationSystemTestCase
  setup do
    # @reservation = reservations(:one)
  end

  test "should redirect gracefully aftern sign_in vía Google Auth" do
    visit root_path
    click_on text: "Mis Reservas"
    click_on text: "Continuar con Google"
    click_on text: "greutter@gmail.com"
    page.assert_current_path reservations_path
  end

  # test "Creating new reservation with pending payment" do
  #   # visit new_reservation_path
  #   # click_on text: "17:00"
  #   # reservation = Reservation.first
  #   # puts reservation.inspect
  #   # assert true
  #   # page.assert_current_path(edit_reservation_path(reservation_id: reservation.id))
  #   # assert_text "PAGO PENDIENTE"
  # end

  # test "click on availale slot should route to reservations/new" do
  #   click_on "17:00"
  #
  #   current_path.should == new_registration_path
  # end

  # test "visiting the index" do
  #   visit reservations_url
  #   assert_selector "h1", text: "Reservations"
  # end
  #
  # test "should create reservation" do
  #   visit reservations_url
  #   click_on "New reservation"
  #
  #   fill_in "Court", with: @reservation.court_id
  #   fill_in "Ends at", with: @reservation.ends_at
  #   fill_in "Starts at", with: @reservation.starts_at
  #   fill_in "User", with: @reservation.user_id
  #   click_on "Create Reservation"
  #
  #   assert_text "Reservation was successfully created"
  #   click_on "Back"
  # end
  #
  # test "should update Reservation" do
  #   visit reservation_url(@reservation)
  #   click_on "Edit this reservation", match: :first
  #
  #   fill_in "Court", with: @reservation.court_id
  #   fill_in "Ends at", with: @reservation.ends_at
  #   fill_in "Starts at", with: @reservation.starts_at
  #   fill_in "User", with: @reservation.user_id
  #   click_on "Update Reservation"
  #
  #   assert_text "Reservation was successfully updated"
  #   click_on "Back"
  # end
  #
  # test "should destroy Reservation" do
  #   visit reservation_url(@reservation)
  #   click_on "Destroy this reservation", match: :first
  #
  #   assert_text "Reservation was successfully destroyed"
  # end
end
