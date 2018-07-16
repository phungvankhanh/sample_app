class PictureUploader < CarrierWave::Uploader::Base
  storage :file
  include CarrierWave::MiniMagick
  # process resize_to_limit: [Settings.limit_size, Settings.limit_size]

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end
