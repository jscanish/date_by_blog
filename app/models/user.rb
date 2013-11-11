class User < ActiveRecord::Base
  has_one :set_of_questions, class_name: "Question"
  has_many :posts, -> {order('created_at DESC')}
  validates :password, presence: true, length: {minimum: 4}
  validates :username, presence: true, uniqueness: true
  validates_presence_of :email

  has_secure_password validations: false

end
