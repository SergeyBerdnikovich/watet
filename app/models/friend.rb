class Friend < ActiveRecord::Base
  belongs_to :authentication
  belongs_to :user

  attr_accessible :authentication_id, :name, :uid, :user_id
end
