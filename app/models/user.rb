class User < ActiveRecord::Base
  has_one :set_of_questions, class_name: "Question"
  has_many :posts, -> {order('created_at DESC')}
  validates :password, presence: true, length: {minimum: 4}
  validates :username, presence: true, uniqueness: true
  validates :address, presence: true
  validates_presence_of :email
  geocoded_by :address

  has_secure_password validations: false

  after_validation :geocode, if: :address_changed?
end
