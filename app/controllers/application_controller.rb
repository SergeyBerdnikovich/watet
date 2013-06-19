class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_locale

  def omniauth_failure
    redirect_to authentications_path, :alert => t(:auth_failed)
  end

  private

  def get_friends_for_(current_user)
    friends = []
    current_user.authentications.each do |authentication|
      authentication.friends.each do |friend|
        friends << friend
      end
    end
    friends
  end

  def check_license
    if current_user
      redirect_to license_path, :alert => t(:tc_need_agree) unless current_user.profile.agreed?
    end
  end

  def agreed?
    self.agreed
  end

  def check_current_user
    redirect_to pages_welcome_path unless user_signed_in?
  end

  def default_url_options(options={})
    logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
  end

  def set_locale
    if current_user && current_user.profile.try(:language)
      I18n.locale = params[:locale] || current_user.profile.try(:language) || session[:locale] || I18n.default_locale
    elsif session[:locale]
      I18n.locale = params[:locale] || session[:locale]
    else
      I18n.locale = params[:locale] || I18n.default_locale
    end
    session[:locale] = I18n.locale
    current_user.profile.update_attribute(:language, I18n.locale) if current_user.try(:profile)
  end
end
