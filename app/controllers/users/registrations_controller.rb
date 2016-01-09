# controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController

  before_filter :configure_permitted_parameters

  protected

  # my custom fields are :name, :heard_how
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:name, :heard_how,
        :email, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:name, :unsubscribe,
        :email, :password, :password_confirmation, :current_password)
    end
  end

end