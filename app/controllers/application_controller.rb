class ApplicationController < ActionController::Base
  protect_from_forgery

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
end
