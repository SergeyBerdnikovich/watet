class ProfilesController < ApplicationController
  before_filter :check_current_user

  def update
    @profile = current_user.profile

    @profile.update_attributes(params[:profile])
    redirect_to root_path
  end
end