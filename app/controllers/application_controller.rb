class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    user_attendances_sammary_path(current_user.id)
  end

  protected

  def configure_permitted_parameters
    added_attrs = %i[user_name work_start_time work_end_time rest_start_time rest_end_time password password_confirmation]
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
