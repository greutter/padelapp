class Users::RegistrationsController < Devise::RegistrationsController

  def update_resource(resource, params)
    resource.update(params)
  end

  def create_resource(resource, params)
    raise
    resource.create(params)
  end

  private

  def resources_params
    params.require(:user).permit(:first_name, :last_name, :email, :phone, :password, :password_confirmation)
  end

  protected
  def after_update_path_for(resource)
    reservations_path
  end

  def after_sign_up_path_for(resource)
    root_path
  end
end
