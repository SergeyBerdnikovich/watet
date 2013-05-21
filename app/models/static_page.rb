class StaticPage < ActiveRecord::Base
  attr_accessible :content, :locale, :name, :title
end
