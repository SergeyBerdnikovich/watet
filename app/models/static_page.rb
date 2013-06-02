class StaticPage < ActiveRecord::Base
	extend FriendlyId
	 friendly_id :title, use: :slugged
  attr_accessible :content, :locale, :name, :title
end
