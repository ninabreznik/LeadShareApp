class RegistrationsController < Devise::RegistrationsController

after_filter :store_location

def create
  super()
  user = User.last
  if user.provider == "provider"
    #UserMailer.welcome_email(user, pass=nil).deliver
  end
end


def store_location
  # store last url as long as it isn't a /users path
  session[:previous_url] = request.fullpath unless request.fullpath =~ /\/users/
end

def after_sign_up_path_for(resource)
  session[:previous_url] || edit_user_registration_path(resource)
end

def after_sign_in_path_for(resource)
  session[:previous_url] || edit_user_registration_path(resource)
end


def sign_up_params
  devise_parameter_sanitizer.sanitize(:sign_up)
end

def account_update_params
  devise_parameter_sanitizer.sanitize(:account_update)
end


private

  # def sign_up_params
  #   params.require(:user).permit(:name, :surname, :city, :bio, :avatar, :email, :password, :password_confirmation)
  # end

  def sign_up_params
    params.require(:user).permit(
      :first_name,
      :surname,
      :business_type,
      :service,
      :de_service,
      :company,
      :tax_id,
      :website,
      :phone,
      :city,
      :hourly_rate,
      :bio,
      :de_bio,
      :picture,
      :email,
      :country,
      :password,
      :password_confirmation,
      :current_password,
      :tracking_id,
      :provider,
      :affiliator)
  end

  def account_update_params
    params.require(:user).permit(
      :first_name,
      :surname,
      :business_type,
      :service,
      :de_service,
      :company,
      :tax_id,
      :website,
      :phone,
      :city,
      :hourly_rate,
      :bio,
      :de_bio,
      :picture,
      :email,
      :country,
      :password,
      :password_confirmation,
      :current_password,
      :tracking_id,
      :provider,
      :affiliator)
  end

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

end
