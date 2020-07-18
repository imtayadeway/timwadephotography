require "bundler/setup"
require "mayatideway/photo"

module Mayatideway
  BUCKET_NAME = "mayatideway"
  TMP_DIR = File.expand_path(File.join(__dir__, "..", "tmp"))
  DATA_DIR = File.expand_path(File.join(__dir__, "..", "_data"))

  AlreadyExists = Class.new(StandardError)

  def self.upload(name:, path:, alt_text:, category:, force: false)
    manifest = Manifest.new(category: category)

    photo = Photo.new(name: name, path: path, alt_text: alt_text)

    resizer = Resizer.new(photo: photo).resize
    resized = resizer.resize

    if !force && manifest.include?(resized)
      raise AlreadyExists
    end

    client = LinodeClient.new(bucket: BUCKET_NAME)
    client.put(path: photo.path)

    manifest.add(photo: photo)

    resizer.cleanup
  end
end
