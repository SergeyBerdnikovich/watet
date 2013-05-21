class Friend < ActiveRecord::Base
  belongs_to :authentication

  attr_accessible :authentication_id, :name, :uid
end
