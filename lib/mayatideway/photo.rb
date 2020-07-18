require "mini_exiftool"

module Mayatideway
  class Photo
    attr_reader :alt_text, :name, :path

    def initialize(name:, path:, alt_text:)
      @name = name
      @path = path
      @alt_text = alt_text
    end

    def basename
      File.basename(path)
    end

    def date_taken
      exif.datetimeoriginal || exif.filemodifydate
    end

    def exif
      @exif ||= MiniExiftool.new(path)
    end
  end
end
