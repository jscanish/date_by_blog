class AddLargeImageToPictures < ActiveRecord::Migration
  def change
    add_column :pictures, :large_image, :string
  end
end
