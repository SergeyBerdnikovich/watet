class UpdateFriendsJob < Struct.new(:user, :token, :uid)
  def perform
    authentication = Authentication.find_by_user_id_and_uid(user.id, uid)
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