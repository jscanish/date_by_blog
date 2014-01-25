class User < ActiveRecord::Base
  has_one :set_of_questions, class_name: "Question"
  has_many :comments
  has_many :messages, -> {order('created_at DESC')}, class_name: "Message", foreign_key: :receiver_id
  has_many :sent_messages, class_name: "Message", foreign_key: :sender_id
  has_many :posts, -> {order('created_at DESC')}
  has_many :pictures, -> {order('created_at DESC')}

  validates :password, presence: true, length: {minimum: 4}
  validates :username, presence: true, uniqueness: true
  validates :address, presence: true
  validates_presence_of :age
  validates_presence_of :email
  geocoded_by :address

  has_secure_password validations: false

  after_validation :geocode, if: :address_changed?

  def unread_messages
    self.messages.where(unread: true)
  end

  def profile_picture
    if self.avatar && picture_exists?
      picture = Picture.where(image: "#{self.avatar}").first
      ActionController::Base.helpers.image_tag(src="#{picture.image_url(:avatar)}")
    else
      ActionController::Base.helpers.image_tag("default_profile.jpg")
    end
  end

  def picture_exists?
    Picture.all.include?(Picture.where(image: "#{self.avatar}").first)
  end
end
