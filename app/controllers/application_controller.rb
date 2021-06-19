class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  protected

  def authenticate_user!
    unless user_signed_in?
      redirect_to '/login', :notice => 'if you want to add a notice'
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:first_name, :last_name, :email, :password, :password_confirmation)}
    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:first_name, :last_name, :email, :password, :current_password)}
  end

  private

  # Overwriting the sign_out redirect path method
  def after_sign_out_path_for(resource_or_scope)
    '/login'
  end

  def after_sign_in_path_for(resource_or_scope)
    '/devices'
  end
end
