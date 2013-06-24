require 'google/api_client'
require 'rubygems'
require 'json'

class UpdateFriendsJob < Struct.new(:user, :token, :uid, :soc_network)
  def perform
    authentication = Authentication.find_by_user_id_and_uid(user.id, uid)
    p authentication
    if authentication.provider == "google_oauth2"
    client = Google::APIClient.new()
    client.authorization.access_token = token
    plus = client.discovered_api('plus')
    friends = client.execute(plus.people.list, :collection => 'visible', :userId => 'me')
    friends = JSON.parse(friends.response.body)['items']    
    friends.each do |friend|
      
      friend_authentication = Authentication.find_by_provider_and_uid('google_oauth2', friend['id'])
      if friend_authentication
        unless Friend.find_by_authentication_id_and_uid(authentication.id, friend['id'])
          authentication.friends << Friend.create!(:name => friend['displayName'],
                                                   :uid => friend['id'],
                                                   :user_id => friend_authentication.user.try(:id))
        end
      end
    end


    else
    FbGraph::User.me(token).fetch.friends.each do |friend|
      friend_authentication = Authentication.find_by_provider_and_uid('facebook', friend.identifier)
      if friend_authentication
        unless Friend.find_by_authentication_id_and_uid(authentication.id, friend.identifier)
          authentication.friends << Friend.create!(:name => friend.name,
                                                   :uid => friend.identifier,
                                                   :user_id => friend_authentication.user.try(:id))
        end
      end
    end
  end



  end
end


