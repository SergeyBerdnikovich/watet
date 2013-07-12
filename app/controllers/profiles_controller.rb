class ProfilesController < ApplicationController
  before_filter :check_current_user
  before_filter :check_license, :except => :update

  def show
    @profile = Profile.where("id = ?", params[:id]).first
    redirect_to root_path if @profile.blank?
  end

  def edit
    @profile = current_user.profile
  end

  def update
    @profile = current_user.profile
    @profile.update_attributes(params[:profile])
    if params['redirect'] == 'root'
      redirect_to root_path
    else
      redirect_to pages_welcome_path()
    end
  end
end