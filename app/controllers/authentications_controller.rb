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
    name = omniauth['info']['name']
    email = omniauth['info']['email']
    session[:soc_name] = name
    session[:soc_email] = email
    # if omniauth['provider'] == 'facebook'
    #   token = omniauth['credentials']['token']
    #   user = FbGraph::User.me(token).fetch
    #   name = user.name #omniauth['info']['name']
    #   email = user.email #omniauth['info']['email']
    #   friends = user.friends  #friend.name friend.id
    # end

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
