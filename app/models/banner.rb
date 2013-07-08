class Banner < ActiveRecord::Base
  attr_accessible :alt, :name, :image, :url
  has_attached_file :image, :styles => { :medium => "300x300>",
                                   :thumb => "100x100>"
                                 }
end

