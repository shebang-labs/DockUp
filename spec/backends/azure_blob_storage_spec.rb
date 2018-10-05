# frozen_string_literal: true

describe Backends::AzureBlobStorage do
  subject { Backends::AzureBlobStorage.new }

  let(:container) { 'dockup' }

  before(:each) do
    allow_any_instance_of(Backends::AzureBlobStorage).to(
      receive(:container_name).and_return(container)
    )

    allow_any_instance_of(Azure::Storage::Blob::BlobService).to(
      receive(:get_container_properties).and_return(true)
    )
  end

  describe '#initialize' do
    it 'should verify_prerequisites! once' do
      expect_any_instance_of(Backends::AzureBlobStorage).to(
        receive(:verify_prerequisites!).once.and_return(true)
      )
      subject
    end

    it 'should check if container exists' do
      expect_any_instance_of(Azure::Storage::Blob::BlobService).to(
        receive(:get_container_properties).once
      )
      subject
    end

    it 'should create container if it does not exist' do
      allow_any_instance_of(Azure::Storage::Blob::BlobService).to(
        receive(:get_container_properties).and_raise(
          Azure::Core::Http::HTTPError,
          Azure::Core::Http::HttpResponse.new(
            AzureMockResponse.new('200', '', {})
          )
        )
      )

      expect_any_instance_of(Azure::Storage::Blob::BlobService).to(
        receive(:create_container).once
      )
      subject
    end
  end

  describe '#client' do
    it 'should create a client, assigns and return it' do
      client = subject.instance_variable_get('@client')
      expect(client).to_not be_nil
      expect(client).to be_a(Azure::Storage::Blob::BlobService)
    end
  end

  describe '#storage_account_name' do
    it 'should use correct storage_account_name from env' do
      expect(subject.send(:storage_account_name)).to(
        eq(ENV['AZURE_STORAGE_ACCOUNT'])
      )
    end
  end

  describe '#storage_access_key' do
    it 'should use correct storage_access_key from env' do
      expect(subject.send(:storage_access_key)).to(
        eq(ENV['AZURE_STORAGE_ACCESS_KEY'])
      )
    end
  end

  describe '#container_name' do
    it 'should use correct container from env' do
      allow_any_instance_of(Backends::AzureBlobStorage).to(
        receive(:container_name).and_call_original
      )
      expect(subject.send(:container_name)).to(
        eq(ENV['AZURE_STORAGE_CONTAINER_NAME'])
      )
    end
  end

  describe '#upload_file' do
    it 'should use Azure client to upload the file' do
      file_path = 'spec/fixtures/folder_to_upload/file_to_upload.txt'
      client = subject.send(:client)
      expect(client).to receive(:create_block_blob).with(
        container,
        file_path,
        anything
      )
      subject.upload_file(file_path)
    end
  end

  describe 'Backends::AzureBlobStorage::PREREQUISITES' do
    it 'should have Azure required credentials and config' do
      expect(Backends::AzureBlobStorage::PREREQUISITES).to match_array(
        %i[ AZURE_STORAGE_ACCESS_KEY
            AZURE_STORAGE_ACCOUNT
            AZURE_STORAGE_CONTAINER_NAME ]
      )
    end
  end
end

# :nocov:
class AzureMockResponse
  def initialize(code, body, headers)
    @status = code
    @body = body
    @headers = headers
    @headers.each do |k, v|
      @headers[k] = [v] unless v.respond_to? 'first'
    end
  end
  attr_accessor :status
  attr_accessor :body
  attr_accessor :headers

  def to_hash
    @headers
  end

  def success?
    true
  end

  def reason_phrase
    ''
  end
end
# :nocov:
