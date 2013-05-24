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
    initial_session(omniauth) unless current_user

    if authentication
      flash[:notice] = 'Signed in sucessfull'
      sign_in_and_redirect(:user, authentication.user)
    elsif current_user
      current_user.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = 'Authentication sucessfull'
      redirect_to authentications_path
    else
      if User.find_by_email(omniauth['info']['email'])
        drop_session
        redirect_to authentications_path, :notice => 'This email is already used by someone, try to go through another social network...'
      else
        initial_session(omniauth)
        user = User.new(:email => omniauth['info']['email'])
        user.authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
        set_profile(user, omniauth)
        user.save
        user.save(:validate => false)
        flash[:notice] = 'Signed in sucessfull'
        sign_in_and_redirect(:user, user)
      end
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
    Delayed::Job.enqueue(UpdateFriendsJob.new(current_user, session[:soc_token], session[:soc_uid])) if current_user && session[:soc_provider] == 'facebook'
  end

  def initial_session(omniauth)
    session[:soc_token] = omniauth['credentials']['token']
    session[:soc_provider] = omniauth['provider']
    session[:soc_uid] = omniauth['uid']
  end

  def drop_session
    session[:soc_token] = nil
    session[:soc_provider] = nil
    session[:soc_uid] = nil
  end

  def set_profile(user, omniauth)
    #session[:soc_email] = omniauth['info']['email']
    if omniauth['provider'] == 'google_oauth2'
      user.build_profile(:fname =>  omniauth['extra']['raw_info']['given_name'],
                         :lname =>  omniauth['extra']['raw_info']['family_name'],
                         :avatar => omniauth['extra']['raw_info']['picture'],
                         :site_link => omniauth['extra']['raw_info']['link'],
                         :agreed => false)
    elsif omniauth['provider'] == 'facebook'
      #fb_user = FbGraph::User.me(omniauth['credentials']['token']).fetch
      user.build_profile(:fname =>  omniauth['info']['first_name'],
                         :lname =>  omniauth['info']['last_name'],
                         :avatar => omniauth['info']['image'],
                         :site_link => omniauth['extra']['raw_info']['link'],
                         :agreed => false)
    end
  end
end
