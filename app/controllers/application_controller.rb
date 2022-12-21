class ApplicationController < ActionController::Base
  # console

  before_action :store_user_location!, if: :storable_location?

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_club

  def set_club
    # @club = Club.find_by(third_party_id: 336)
  end

  def storable_location?
    request.get? && is_navigational_format? && !devise_controller? &&
      !request.xhr?
  end

  def store_user_location!
    # :user is the scope we are authenticating
    session[:redirect_path] = request.fullpath unless user_signed_in?
  end

  def after_sign_in_path_for(user)
    session[:redirect_path] || root_path
  end

  def after_sign_in_path_for(user)
    session[:redirect_path] || root_path
  end

  def after_sign_out_path_for(user)
    root_path
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
