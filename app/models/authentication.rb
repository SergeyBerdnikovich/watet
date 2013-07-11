class Authentication < ActiveRecord::Base
  belongs_to :user
  has_many :friends, :dependent => :destroy

  attr_accessible :provider, :uid, :user_id
end
