class User < ActiveRecord::Base
  validates :password, presence: true, length: {minimum: 4}
  validates :username, presence: true, uniqueness: true
  validates_presence_of :email

  has_secure_password validations: false
end
