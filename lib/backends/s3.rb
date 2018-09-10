# frozen_string_literal: true

require 'aws-sdk-s3'
require './lib/backends/base'

module Backends
  class S3 < Base
    PREREQUISITES = %i[ AWS_ACCESS_KEY_ID
                        AWS_SECRET_ACCESS_KEY
                        AWS_REGION
                        AWS_BUCKET ].freeze

    def initialize
      super
      resource = Aws::S3::Resource.new(region: region)
      return if resource.bucket(bucket).exists?

      client.create_bucket(bucket: bucket)
    end

    def upload_file(file)
      File.open(file) do |body|
        file[0] = '' if file[0] == '/'
        client.put_object(bucket: bucket, key: file, body: body)
      end
    end

    private

    def client
      @client ||= Aws::S3::Client.new(
        access_key_id: key_id,
        secret_access_key: access_key,
        region: region
      )
    end

    def key_id
      ENV['AWS_ACCESS_KEY_ID']
    end

    def access_key
      ENV['AWS_SECRET_ACCESS_KEY']
    end

    def region
      ENV['AWS_REGION']
    end

    def bucket
      ENV['AWS_BUCKET']
    end
  end
end
