class ApplicationController < ActionController::Base
  protect_from_forgery

  private

  def check_license
    if current_user
      redirect_to license_path unless current_user.profile.agreed?
    end
  end

  def agreed?
    self.agreed
  end

  def check_current_user
    redirect_to pages_welcome_path unless user_signed_in?
  end
end
