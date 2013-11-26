class Post < ActiveRecord::Base
  has_many :comments, -> {order('created_at DESC')}
  belongs_to :user
  validates :title, presence: true
  validates :body, presence: true
end
