class ListItem < ActiveRecord::Base
  attr_accessible :images_attributes
  has_many :images, :dependent => :destroy
  accepts_nested_attributes_for :images
  attr_accessible :description, :geloc, :priority, :title, :user_id, :url

  belongs_to :user
  before_save :add_url

  def add_url
    if self.title =~ /^http[s]{0,1}:\/\/[a-z1-9.\/@A-Z?=]+/ || self.title =~ /^www.[a-z1-9.\/@A-Z?=]+/
      self.url = self.title 
    
    begin
      uri = URI(self.url)
      str = Net::HTTP.get(uri),{:open_timeout => 2, :read_timeout => 4 }
      #raise str.inspect.to_s
      title = str.to_s.match(/(?:<title[^>]*?>)(.*?)(?:<\/title>)/m)[1]
      self.title  = title if title
    rescue
    end 

    end
  end

  def as_json(options={})
    super(  :only => [:id,:title,:description,:priority,:user_id]   )
  end
end
