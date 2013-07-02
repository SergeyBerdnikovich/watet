require 'update_friends_job'
require 'google/api_client'
class AuthenticationsController < ApplicationController
  after_filter :set_friends, :only => [:create]
  before_filter :check_license, :except => [:create]

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

    if current_user
      if authentication #if such user with such SN already exists
        # flash[:error] = 'You have already register another account with that social network'
        # redirect_to authentications_path and return false
        accounts_merge(authentication)
        sign_in_and_redirect(:user, authentication.user)
      else
        current_user.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'])
        redirect_to authentications_path, :notice => 'Authentication sucessfull'
      end
    elsif authentication
      flash[:notice] = 'Signed in sucessfull'
      sign_in_and_redirect(:user, authentication.user)
    else
      if User.find_by_email(omniauth['info']['email'])
        user = User.new(:email => omniauth['provider'] + ":" +omniauth['info']['email'])
      else
        user = User.new(:email => omniauth['info']['email'])
      end
      #initial_session(omniauth)
      user.authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
      set_profile(user, omniauth)
      user.save
      user.save(:validate => false)
      flash[:notice] = 'Signed in sucessfull'
      sign_in_and_redirect(:user, user)
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
    Delayed::Job.enqueue(UpdateFriendsJob.new(current_user, session[:soc_token], session[:soc_uid]))
  end

  def initial_session(omniauth)
    session[:soc_token] = omniauth['credentials']['token']
    session[:soc_provider] = omniauth['provider']
    session[:soc_uid] = omniauth['uid']
  end

  def set_profile(user, omniauth)
    #session[:soc_email] = omniauth['info']['email']
    if omniauth['provider'] == 'google_oauth2'
      avatar = omniauth['extra']['raw_info']['picture']
      avatar = 'default.gif' unless avatar != ""
      user.build_profile(:fname =>  omniauth['extra']['raw_info']['given_name'],
                         :lname =>  omniauth['extra']['raw_info']['family_name'],
                         :avatar => avatar,
                         :site_link => omniauth['extra']['raw_info']['link'],
                         :agreed => false)
    elsif omniauth['provider'] == 'facebook'
      #fb_user = FbGraph::User.me(omniauth['credentials']['token']).fetch
      avatar = omniauth['info']['image']
      avatar = 'default.gif' unless avatar != ""

      user.build_profile(:fname =>  omniauth['info']['first_name'],
                         :lname =>  omniauth['info']['last_name'],
                         :avatar => avatar,
                         :site_link => omniauth['extra']['raw_info']['link'],
                         :agreed => false)
    end
  end

  def accounts_merge(authentication)
    id = authentication.user.id
    authentication.user.list_items.each do |list_item|
      list_item.update_attribute(:user_id, current_user.id)
    end
    authentication.friends.each do |friend|
      friend.destroy
    end
    authentication.update_attribute(:user_id, current_user.id)
    User.find(id).destroy
  end
end

