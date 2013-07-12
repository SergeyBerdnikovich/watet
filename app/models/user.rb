class User < ActiveRecord::Base
  has_many :authentications, :dependent => :destroy
  has_many :list_items, :dependent => :destroy
  has_one :profile, :dependent => :destroy
  has_many :friends, :dependent => :destroy
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
              :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
  extend FriendlyId
  friendly_id :profile_name, use: :slugged

  private

  def profile_name
    "#{profile.try(:fname)}-#{profile.try(:lname)}"
  end
end
