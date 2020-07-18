module Mayatideway
  class LinodeClient
    attr_reader :bucket

    def initialize(bucket:)
      @bucket = bucket
    end

    def put(path:)
      system("linode-cli obj put --acl-public #{path} #{bucket}")
    end

    def get(name:, as:)
      system("linode-cli obj get #{bucket} #{name} #{File.join(TMP_DIR, as)}")
    end

    def delete(name:)
      system("linode-cli obj del #{bucket} #{name}")
    end
  end
end
