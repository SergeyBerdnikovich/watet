class User < ActiveRecord::Base
  has_many :authentications
  has_many :list_items
  has_one :profile
  has_many :friends
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
    "#{profile.try(:fname)}"
  end
end
