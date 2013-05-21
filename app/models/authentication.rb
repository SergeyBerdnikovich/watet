class Authentication < ActiveRecord::Base
  belongs_to :user
  has_many :friends

  attr_accessible :provider, :uid, :user_id
end
