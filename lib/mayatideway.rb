require "bundler/setup"
require "mayatideway/linode_client"
require "mayatideway/manifest"
require "mayatideway/photo"
require "mayatideway/resizer"

module Mayatideway
  BUCKET_NAME = "mayatideway"
  TMP_DIR = File.expand_path(File.join(__dir__, "..", "tmp"))
  DATA_DIR = File.expand_path(File.join(__dir__, "..", "_data"))

  AlreadyExists = Class.new(StandardError)

  def self.upload(name:, path:, alt_text:, category:, force: false)
    manifest = Manifest.new(category: category)

    photo = Photo.new(name: name, path: path, alt_text: alt_text)

    resizer = Resizer.new(photo: photo)
    resized = resizer.resize

    if !force && manifest.include?(resized)
      raise AlreadyExists
    end

    client = LinodeClient.new(bucket: BUCKET_NAME)
    client.put(path: photo.path)

    manifest.add(photo: resized)

    resizer.cleanup
  end

  def self.rename(old_name:, new_name:, category:)
    manifest = Manifest.new(category: category)

    client = LinodeClient.new(bucket: BUCKET_NAME)
    photo = client.get(name: old_name) # --> tmp

    renamer = Renamer.new(photo: photo, name: new_name)

    client.put(path: photo.path)

    manifest.rename(from: old_name, to: new_name)

    client.delete(name: old_name)

    rename.cleanup
  end
end
