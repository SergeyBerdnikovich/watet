class ProfilesController < ApplicationController
  before_filter :check_current_user

  def show
    #@profile = Profile.find(params[:id])
    @profile = Profile.where("id = ?", params[:id]).first
    redirect_to root_path if @profile.blank?
  end

  def edit
    @profile = current_user.profile
  end

  def update
    @profile = current_user.profile

    @profile.update_attributes(params[:profile])
    redirect_to profile_path(@profile)
  end
end