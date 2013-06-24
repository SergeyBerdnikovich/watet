require 'google/api_client'
require 'rubygems'
require 'json'

class UpdateFriendsJob < Struct.new(:user, :token, :uid)
  def perform
    authentication = Authentication.find_by_user_id_and_uid(user.id, uid)
    if authentication.provider == "google_oauth2"
      get_google_plus_friends(token).each do |friend|
        add_new_friend(authentication, friend['id'], friend['displayName'])
      end
    else
      FbGraph::User.me(token).fetch.friends.each do |friend|
        add_new_friend(authentication, friend.identifier, friend.name)
      end
    end
  end

  def add_new_friend(authentication, friend_uid, friend_name)
    friend_authentication = Authentication.find_by_provider_and_uid(authentication.provider, friend_uid)
    if friend_authentication && Friend.find_by_user_id_and_authentication_id(friend_authentication.user.try(:id), [user.authentications.map{|aut| [aut.id]}]).blank?
      authentication.friends << Friend.create!(:name => friend_name,
                                               :uid => friend_uid,
                                               :user_id => friend_authentication.user.try(:id))
    end
  end

  def get_google_plus_friends(token)
    client = Google::APIClient.new()
    client.authorization.access_token = token
    plus = client.discovered_api('plus')
    friends = client.execute(plus.people.list, :collection => 'visible', :userId => 'me')
    JSON.parse(friends.response.body)['items'] || []
  end
end
