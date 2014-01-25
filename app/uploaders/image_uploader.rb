class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  version :small do
    process :resize_to_fill => [166, 236]
  end

  version :large do
    process :resize_to_limit => [765, 475]
  end

  version :avatar do
    process :resize_to_fill => [160, 160]
  end

  # storage :file

  # def store_dir
  #   "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  # end

end
