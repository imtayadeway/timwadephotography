require "yaml"

module Mayatideway
  class Manifest
    attr_reader :category

    def initialize(category:)
      @category = category
    end

    def add(photo: photo)
      data = begin
               YAML.load_file(manifest_path, fallback: [])
             rescue
               []
             end

      data << { "name" => photo.basename, "alt-text" => photo.alt_text }

      File.open(manifest_path, "w") do |file|
        file.write(YAML.dump(data.sort_by { |hash| hash["name"] }.reverse))
      end
    end

    def manifest_path
      File.join(DATA_DIR, "#{category}.yml")
    end
  end
end
