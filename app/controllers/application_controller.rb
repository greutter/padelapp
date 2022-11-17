class ApplicationController < ActionController::Base
  # console

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_club

  def set_club
    # @club = Club.find_by(third_party_id: 336)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: %i[first_name last_name email phone password password_confirmation]
    )
    devise_parameter_sanitizer.permit(
      :account_update,
      keys: %i[first_name last_name phone email]
    )
  end
end
