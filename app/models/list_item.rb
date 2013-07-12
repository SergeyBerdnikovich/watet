class ListItem < ActiveRecord::Base
  attr_accessible :images_attributes
  has_many :images, :dependent => :destroy
  accepts_nested_attributes_for :images
  attr_accessible :description, :geloc, :priority, :title, :user_id, :url

  belongs_to :user
  before_save :add_url

  def add_url #add url if it were specified in title

    if self.title =~ /^http[s]{0,1}:\/\/[a-z1-9.\/@A-Z?=]+/ || self.title =~ /^www.[a-z1-9.\/@A-Z?=]+/
      self.url = self.title

      begin
        url = URI(self.url)
        res = Net::HTTP.start(url.host, url.port,{:open_timeout => 3000, :read_timeout => 6000 }) {|http|
          str =  http.get(url.path)
        }
        url = res['location']
        unless url.blank?
          url = URI(url) #get
          str = Net::HTTP.get(url),{:open_timeout => 3000, :read_timeout => 6000 }
        end
        title = str.to_s.match(/(?:<title[^>]*?>)(.*?)(?:<\/title>)/mi)[1]
        self.title  = title if title
      rescue
      end

    end
  end

  def as_json(options={})
    super(  :only => [:id,:title,:description,:priority,:user_id]   )
  end
end
