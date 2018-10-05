# frozen_string_literal: true

require 'google/cloud/storage'
require './lib/backends/base'

module Backends
  class GCP < Base
    PREREQUISITES = %i[
      GCP_CREDENTIALS
      GCP_PROJECT_ID
      GCP_BUCKET_NAME
     ].freeze

    def initialize
      super
      Google::Cloud::Storage.configure do |config|
        config.project_id = project_id
        config.credentials = credentials
      end
    end

    def upload_file(file)
      File.open(file) do |body|
        file[0] = '' if file[0] == '/'
        bucket.create_file body file
      end
    end

    private

    def storage
      @storage ||= Google::Cloud::Storage.new
    end

    def bucket
      if storage.get(bucket_name, Storage.BucketGetOption.fields()) == null
        storage.create_bucket bucket_name
      end
      @bucket ||= storage.bucket bucket_name
    end

    def credentials
      ENV['GCP_KEY']
    end

    def project_id
      ENV['GCP_PROJECT_ID']
    end

    def bucket_name
      ENV['GCP_BUCKET_NAME']
    end
  end
end
