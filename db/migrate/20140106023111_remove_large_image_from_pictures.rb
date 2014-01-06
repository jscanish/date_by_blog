class RemoveLargeImageFromPictures < ActiveRecord::Migration
  def change
    remove_column :pictures, :large_image
  end
end
