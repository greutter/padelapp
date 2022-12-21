class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token

  def google_oauth2
    user = User.from_omniauth(auth)
    
    if user.present?
      sign_out_all_scopes
      flash[:success] = t "devise.omniauth_callbacks.success", kind: "Google"
      sign_in user, event: :authentication
      redirect_to request.env["omniauth.params"]["redirect_path"] || root_path
    else
      flash[:alert] = "Algo falló al intentar iniciar sesión con Google :("
      redirect_to new_user_session_path
    end
  end

  protected

  def after_omniauth_failure_path_for(_scope)
    new_user_session_path
  end

  private

  def auth
    @auth ||= request.env["omniauth.auth"]
  end
end
