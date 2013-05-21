class AuthenticationsController < ApplicationController
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
    session[:soc_email] = omniauth['info']['email']
    token = omniauth['credentials']['token']
    session[:soc_token] = token

    if omniauth['provider'] == 'google_oauth2'
      session[:soc_name] = omniauth['extra']['raw_info']['given_name']
      session[:soc_ava] = omniauth['extra']['raw_info']['picture']
    elsif omniauth['provider'] == 'facebook'
      fb_user = FbGraph::User.me(token).fetch
      session[:soc_name] = omniauth['info']['first_name']
      session[:soc_ava] = FbGraph::User.me(token).fetch.picture
      #friends = fb_user.friends  #friend.name friend.id
    end

    if authentication
      sign_in_and_redirect(:user, authentication.user)
      flash[:notice] = 'Signed in sucessfull'
    elsif current_user
      current_user.authentications.create(:provider => omniauth['provider'], :uid => omniauth['uid'])
      flash[:notice] = 'Authentication sucessfull'
      redirect_to authentications_path
    else
      user = User.new
      user.authentications.build(:provider => omniauth['provider'], :uid => omniauth['uid'])
      user.email = omniauth['provider'] + ":" + user.email
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
end
