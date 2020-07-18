require "yaml"

module Mayatideway
  class Manifest
    attr_reader :category

    def initialize(category:)
      @category = category
    end

    def find(name:)
      data = begin
               YAML.load_file(manifest_path, fallback: [])
             rescue
               []
             end
      data.detect { |d| d["name"] == name }
    end

    def add(photo:)
      data = begin
               YAML.load_file(manifest_path, fallback: [])
             rescue
               []
             end

      data << { "name" => photo.name, "alt-text" => photo.alt_text }

      File.open(manifest_path, "w") do |file|
        file.write(YAML.dump(data.sort_by { |hash| hash["name"] }.reverse))
      end
    end

    def rename(from:, to:)
      data = begin
               YAML.load_file(manifest_path, fallback: [])
             rescue
               []
             end
      data.detect { |d| d["name"] == from }["name"] = to
      File.open(manifest_path, "w") do |file|
        file.write(YAML.dump(data.sort_by { |hash| hash["name"] }.reverse))
      end
    end

    def include?(photo)
      data = begin
               YAML.load_file(manifest_path, fallback: [])
             rescue
               []
             end
      data.any? { |d| d["name"] == photo.basename }
    end

    def manifest_path
      File.join(DATA_DIR, "#{category}.yml")
    end
  end
end
