require "fileutils"

module Mayatideway
  class Resizer
    COMMAND = lambda do |infn, outfn|
      <<~EOF
        gimp --no-interface \
             --batch="(let* ((in-filename \\"#{infn}\\")
                            (out-filename \\"#{outfn}\\")
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

    attr_reader :photo

    def initialize(photo:)
      @photo = photo
    end

    def resize
      ensure_tmp_dir
      resize_to_tmp
      Photo.new(
        name: cloud_filename,
        path: tmp_path,
        alt_text: photo.alt_text
      )
    end

    def cleanup
      "nope"
    end

    def tmp_path
      File.join(TMP_DIR, cloud_filename)
    end

    def cloud_filename
      [photo.date_taken.strftime("%Y-%m-%d"), "#{photo.name}.jpg"].join("-")
    end

    def ensure_tmp_dir
      FileUtils.mkdir_p(TMP_DIR)
    end

    def resize_to_tmp
      system(COMMAND.call(photo.path, tmp_path))
    end
  end
end
