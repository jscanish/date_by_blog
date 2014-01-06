class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.integer :user_id
      t.string :image
      t.string :title
      t.text :description
      t.timestamps
    end
  end
end
