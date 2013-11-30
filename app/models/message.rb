class Message < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :title
  validates_presence_of :body

  after_validation :set_to_true

  def set_to_true
    self.unread = true
  end

  def sender
    id = self.sender_id
    User.where(id: id).first
  end

  def receiver
    id = self.receiver_id
    User.where(id: id).first
  end
end
