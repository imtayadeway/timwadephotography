module Mayatideway
  class LinodeClient
    def initialize(bucket:)
      @bucket = bucket
    end

    def put(path:)
      system("linode-cli obj put --acl-public #{path} #{bucket}")
    end
  end
end
