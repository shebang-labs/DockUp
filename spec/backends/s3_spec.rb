# frozen_string_literal: true

describe Backends::S3 do
  subject { Backends::S3.new }

  let(:bucket) { 'dockup' }
  let(:bucket_exists) { true }

  before(:each) do
    allow_any_instance_of(Backends::S3).to receive(:bucket).and_return(bucket)
    allow_any_instance_of(Aws::S3::Bucket).to(
      receive(:exists?).and_return(bucket_exists)
    )
    allow_any_instance_of(Aws::S3::Client).to receive(:put_object)
  end

  describe '#initialize' do
    context 'bucket exists' do
      it 'should verify_prerequisites! once' do
        expect_any_instance_of(Backends::S3).to(
          receive(:verify_prerequisites!).once.and_return(true)
        )
        subject
      end

      it 'should check if bucket exists' do
        expect_any_instance_of(Aws::S3::Bucket).to(
          receive(:exists?).once
        )
        subject
      end
    end
    context 'bucket does not exist' do
      let(:bucket_exists) { false }
      it 'should creaet the bucket if does not exist' do
        expect_any_instance_of(Aws::S3::Client).to(
          receive(:create_bucket).with(bucket: bucket).once
        )
        subject
      end
    end
  end

  describe '#client' do
    it 'should create a client, assigns and return it' do
      client = subject.instance_variable_get('@client')
      expect(client).to be_nil
      returned_client = subject.send(:client)
      expect(returned_client).to_not be_nil
      client = subject.instance_variable_get('@client')
      expect(client).to_not be_nil
      expect(client).to eq(returned_client)
    end
  end

  describe '#key_id' do
    it 'should use correct key_id from env' do
      expect(subject.send(:key_id)).to eq(ENV['AWS_ACCESS_KEY_ID'])
    end
  end

  describe '#access_key' do
    it 'should use correct access_key from env' do
      expect(subject.send(:access_key)).to eq(ENV['AWS_SECRET_ACCESS_KEY'])
    end
  end

  describe '#region' do
    it 'should use correct region from env' do
      expect(subject.send(:region)).to eq(ENV['AWS_REGION'])
    end
  end

  describe '#bucket' do
    it 'should use correct bucket from env' do
      allow_any_instance_of(Backends::S3).to receive(:bucket).and_call_original
      expect(subject.send(:bucket)).to eq(ENV['AWS_BUCKET'])
    end
  end

  describe '#upload_file' do
    it 'should use S3 client to upload the file' do
      file_path = 'spec/fixtures/folder_to_upload/file_to_upload.txt'
      client = subject.send(:client)
      expect(client).to receive(:put_object).with(
        hash_including(
          bucket: bucket,
          key: file_path
        )
      )
      subject.upload_file(file_path)
    end
  end

  describe 'Backends::S3::PREREQUISITES' do
    it 'should have S3 required credentials and config' do
      expect(Backends::S3::PREREQUISITES).to match_array(
        %i[ AWS_ACCESS_KEY_ID
            AWS_SECRET_ACCESS_KEY
            AWS_REGION
            AWS_BUCKET ]
      )
    end
  end
end
