class Image < ActiveRecord::Base
	  belongs_to :list_item
  attr_accessible :list_item_id, :image

  has_attached_file :image, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
end
