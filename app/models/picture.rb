class Picture < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :title, :image

  mount_uploader :image, ImageUploader
end
