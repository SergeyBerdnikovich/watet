class PagesController < ApplicationController
  def welcome
    if current_user
      authentication = current_user.authentications.where(:provider => 'facebook')
      @friends = []
      current_user.authentications.each do |authentication|
        authentication.friends.each do |friend|
          @friends << friend
        end
      end
      #@friends = Friend.where(:authentication_id => authentication.id)
    end
    @friends ||= []
  end
end
