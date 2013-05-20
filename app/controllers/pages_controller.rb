class PagesController < ApplicationController
  def welcome
    if current_user && session[:soc_token].presence
      fb_user = FbGraph::User.me(session[:soc_token]).fetch
      @friends = fb_user.friends
    end
  end
end
