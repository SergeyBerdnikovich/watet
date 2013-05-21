require 'update_friends_job'
class AuthenticationsController < ApplicationController
  after_filter :set_friends, :only => [:create]

  # GET /authentications
  # GET /authentications.json
  def index
    @authentications = current_user.authentications if current_user
  end

  # POST /authentications
  # POST /authentications.json
  def create
    omniauth = request.env["omniauth.auth"]
    authentication = Authentication.find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    initial_session(omniauth)

    if authentication
      sign_in_and_redirect(:user, authentication.user)
      flash[:notice] = 'Signed in sucessfull'
    elsif current_user
      current_user.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = 'Authentication sucessfull'
      redirect_to authentications_path
    else
      user = User.new(:email => omniauth['info']['email'])
      user.authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
      user.save(:validate => false)
      sign_in_and_redirect(:user, user)
      flash[:notice] = 'Signed in sucessfull'
    end
  end

  # DELETE /authentications/1
  # DELETE /authentications/1.json
  def destroy
    @authentication = current_user.authentications.find(params[:id])
    @authentication.destroy

    respond_to do |format|
      format.html { redirect_to authentications_url }
      format.json { head :no_content }
    end
  end

  private

  def set_friends
    Delayed::Job.enqueue(UpdateFriendsJob.new(current_user, session[:soc_token], session[:soc_uid])) if session[:soc_provider] == 'facebook'
  end

  def initial_session(omniauth)
    session[:soc_email] = omniauth['info']['email']
    session[:soc_token] = omniauth['credentials']['token']
    session[:soc_provider] = omniauth['provider']
    session[:soc_uid] = omniauth['uid']
    if omniauth['provider'] == 'google_oauth2'
      session[:soc_name] = omniauth['extra']['raw_info']['given_name']
      session[:soc_ava] = omniauth['extra']['raw_info']['picture']
    elsif omniauth['provider'] == 'facebook'
      fb_user = FbGraph::User.me(omniauth['credentials']['token']).fetch
      session[:soc_name] = omniauth['info']['first_name']
      session[:soc_ava] = fb_user.picture
    end
  end
end
