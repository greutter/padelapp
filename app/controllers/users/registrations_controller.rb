class Users::RegistrationsController < Devise::RegistrationsController

  def update_resource(resource, params)
    resource.update(params)
  end


  private

  def resources_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone)
  end

  protected
  def after_update_path_for(resource)
     edit_registration_path(resource)
  end

  def after_sign_up_path_for(resource)
    shares_path
  end
end
