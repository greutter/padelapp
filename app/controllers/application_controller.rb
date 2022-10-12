class ApplicationController < ActionController::Base
  # console

  before_action :redirect_to_domain
  before_action :configure_permitted_parameters, if: :devise_controller?

  def redirect_to_domain
    host = request.host
    path = path = request.fullpath.split("?")[0]
    if host == 'padelapp.cl' && path == "/"
      # redirect_to 'https://padelapp.cl'
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :email])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :phone, :email])
  end


end
