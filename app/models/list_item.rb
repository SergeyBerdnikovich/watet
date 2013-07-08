class ListItem < ActiveRecord::Base
  attr_accessible :images_attributes
  has_many :images, :dependent => :destroy
  accepts_nested_attributes_for :images
  attr_accessible :description, :geloc, :priority, :title, :user_id, :url

  belongs_to :user
  before_save :add_url

  def add_url
    self.url ||= self.title if self.title =~ /^http:\/\/[a-z1-9.\/@A-Z?=]+/ || self.title =~ /^www.[a-z1-9.\/@A-Z?=]+/
  end

  def as_json(options={})
    super(  :only => [:id,:title,:description,:priority,:user_id]   )
  end
end
