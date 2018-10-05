# frozen_string_literal: true

require 'azure/storage/blob'
require_relative 'base'

module Backends
  class AzureBlobStorage < Base
    PREREQUISITES = %i[
      AZURE_STORAGE_ACCOUNT
      AZURE_STORAGE_ACCESS_KEY
      AZURE_STORAGE_CONTAINER_NAME
    ].freeze

    def initialize
      super
      client.get_container_properties(container_name)
    rescue Azure::Core::Http::HTTPError
      client.create_container(container_name)
    end

    def upload_file(file)
      File.open(file) do |body|
        file[0] = '' if file[0] == '/'
        client.create_block_blob(container_name, file, body)
      end
    end

    private

    def client
      @client ||= Azure::Storage::Blob::BlobService.create(
        storage_account_name: storage_account_name,
        storage_access_key: storage_access_key
      )
    end

    def storage_account_name
      ENV['AZURE_STORAGE_ACCOUNT']
    end

    def storage_access_key
      ENV['AZURE_STORAGE_ACCESS_KEY']
    end

    def container_name
      ENV['AZURE_STORAGE_CONTAINER_NAME']
    end
  end
end
