class AddUnreadToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :unread, :boolean
  end
end
