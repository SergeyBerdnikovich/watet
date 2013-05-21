class ListItem < ActiveRecord::Base
  attr_accessible :description, :geloc, :priority, :title

  belongs_to :user
end
