class ListItem < ActiveRecord::Base
  attr_accessible :description, :geloc, :priority, :title, :user_id

  belongs_to :user
end
