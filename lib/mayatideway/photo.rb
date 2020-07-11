require "fileutils"
require "bundler/setup"
require "mini_exiftool"

module Mayatideway
  class Photo
    BUCKET_NAME = "mayatideway"
    DATED_FILENAME_REGEX = /\A\d{4}-\d{2}-\d{2}/
    TMP_DIR = File.expand_path(File.join(__dir__, "..", "..", "tmp"))

    attr_reader :path

    def initialize(path:, alt_text:, category:)
      @path = path
      @alt_text = alt_text
      @category = category
    end

    def upload
      ensure_tmp_dir
      resize_to_tmp
      do_upload
      add_to_manifest
      cleanup
    end

    private

    def ensure_tmp_dir
      FileUtils.mkdir_p(TMP_DIR)
    end

    def resize_to_tmp
      system(<<~EOF)
        gimp --no-interface \
             --batch="(let* ((in-filename \\"#{path}\\")
                            (out-filename \\"#{tmp_path}\\")
                            (image (car (gimp-file-load RUN-NONINTERACTIVE in-filename in-filename)))
                            (drawable (car (gimp-image-get-active-layer image)))
                            (old-width (car (gimp-image-width image)))
                            (old-height (car (gimp-image-height image)))
                            (scale-factor (/ 1500 (max old-width old-height)))
                            (new-width (* scale-factor old-width))
                            (new-height (* scale-factor old-height)))
                       (gimp-image-scale image new-width new-height)
                       (file-jpeg-save RUN-NONINTERACTIVE image drawable out-filename out-filename 0.85 0 1 1 \\"\\" 2 1 0 0)
                       (gimp-image-delete image))" \
             --batch='(gimp-quit 0)'
      EOF
    end

    def tmp_path
      File.join(TMP_DIR, tmp_filename)
    end

    def tmp_filename
      if in_filename =~ DATED_FILENAME_REGEX
        in_filename
      else
        [date_taken.strftime("%Y-%m-%d"), in_filename].join("-")
      end
    end

    def in_filename
      File.basename(path)
    end

    def date_taken
      exif.datetimeoriginal
    end

    def exif
      @exif ||= MiniExiftool.new(path)
    end

    def do_upload
      return "nope"
      system("linode-cli obj put --acl-public #{tmp_path} #{BUCKET_NAME}")
    end

    def add_to_manifest
      "nope"
    end

    def cleanup
      "nope"
    end
  end
end
