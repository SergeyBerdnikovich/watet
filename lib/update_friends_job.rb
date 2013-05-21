class UpdateFriendsJob < Struct.new(:user, :token, :uid)
  def perform
    authentication = Authentication.find_by_user_id_and_uid(user.id, uid)
    FbGraph::User.me(token).fetch.friends.each do |friend|
      unless Friend.find_by_authentication_id_and_uid(authentication.id, friend.identifier)
        authentication.friends << Friend.create!(:name => friend.name, :uid => friend.identifier)
      end
    end
  end
end