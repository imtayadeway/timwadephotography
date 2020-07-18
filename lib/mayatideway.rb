require "bundler/setup"
require "mayatideway/photo"

module Mayatideway
  BUCKET_NAME = "mayatideway"
  TMP_DIR = File.expand_path(File.join(__dir__, "..", "tmp"))
  DATA_DIR = File.expand_path(File.join(__dir__, "..", "_data"))

  # TODO:
  # 1. refactor
  # 2. must --force to overrite existing
  def self.upload(name:, path:, alt_text:, category:)
    photo = Photo.new(name: name, path: path, alt_text: alt_text)

    resizer = Resizer.new(photo: photo).resize
    resized = resizer.resize

    client = LinodeClient.new(bucket: BUCKET_NAME)
    client.put(path: photo.path)

    Manifest.new(category: category).add(photo: photo)

    resizer.cleanup
  end
end
