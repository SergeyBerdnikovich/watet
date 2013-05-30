class ListItem < ActiveRecord::Base
  attr_accessible :images_attributes
  has_many :images, :dependent => :destroy
  accepts_nested_attributes_for :images
  attr_accessible :description, :geloc, :priority, :title, :user_id 
  

  
  
  belongs_to :user


end
