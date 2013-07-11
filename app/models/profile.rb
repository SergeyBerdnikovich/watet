class Profile < ActiveRecord::Base
  attr_accessible :agreed, :avatar, :city, :fname, :lname, :phone, :state, :user_id, :zip, :site_link, :language

  belongs_to :user
end
