require "mayatideway/photo"

module Mayatideway
  def self.upload(name:, path:, alt_text:, category:)
    Photo.new(
      name: name,
      path: path,
      alt_text: alt_text,
      category: category
    ).upload
  end
end
