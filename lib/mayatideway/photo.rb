require "fileutils"
require "bundler/setup"
require "mini_exiftool"
require "yaml"

# TODO:
# 1. refactor
# 2. must --force to overrite existing

module Mayatideway
  class Photo
    BUCKET_NAME = "mayatideway"
    TMP_DIR = File.expand_path(File.join(__dir__, "..", "..", "tmp"))
    DATA_DIR = File.expand_path(File.join(__dir__, "..", "..", "_data"))

    attr_reader :alt_text, :category, :name, :path

    def initialize(name:, path:, alt_text:, category:)
      @name = name
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
      [date_taken.strftime("%Y-%m-%d"), out_filename].join("-")
    end

    def in_filename
      File.basename(path)
    end

    def out_filename
      "#{name}.jpg"
    end

    def date_taken
      exif.datetimeoriginal || exif.filemodifydate
    end

    def exif
      @exif ||= MiniExiftool.new(path)
    end

    def do_upload
      system("linode-cli obj put --acl-public #{tmp_path} #{BUCKET_NAME}")
    end

    def add_to_manifest
      data = begin
               YAML.load_file(manifest_path, fallback: [])
             rescue
               []
             end

      data << { "name" => tmp_filename, "alt-text" => alt_text }

      File.open(manifest_path, "w") do |file|
        file.write(YAML.dump(data.sort_by { |hash| hash["name"] }.reverse))
      end
    end

    def manifest_path
      File.join(DATA_DIR, "#{category}.yml")
    end

    def cleanup
      "nope"
    end
  end
end
