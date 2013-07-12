class StaticPagesController < ApplicationController
  before_filter :check_current_user, :except => [:show]

  # GET /static_pages/1
  # GET /static_pages/1.json
  def show
    @static_page = StaticPage.find(params[:id])
    flash.clear
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @static_page }
    end
  end

  def license
    @profile = current_user.profile
    if current_user.sign_in_count == 1
      flash[:notice] == nil
    end
    redirect_to root_path if @profile.agreed.present?
  end

  private

  def check_current_user
    redirect_to pages_welcome_path unless user_signed_in?
  end
end
