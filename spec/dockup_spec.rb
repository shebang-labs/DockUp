# frozen_string_literal: true

describe DockUp do
  let(:bucket) { 'dockup' }
  let(:uploader) { Backends::S3.new }
  let(:dockup) { DockUp.new(uploader) }
  let(:src) { ENV.fetch('DockUpSrc', '.') }

  before(:each) do
    allow_any_instance_of(Backends::S3).to receive(:bucket).and_return(bucket)
    allow_any_instance_of(Aws::S3::Bucket).to receive(:exists?).and_return(true)
    allow_any_instance_of(Aws::S3::Client).to receive(:put_object)
  end

  describe '#initialize' do
    it 'should initiate a dockup object with provided backend' do
      expect(dockup.uploader).to_not be(nil)
      expect(dockup.uploader).to be_a(Backends::S3)
    end
  end

  describe '#upload' do
    it 'should call upload on the uploader' do
      expect(dockup.uploader).to receive(:upload).with(src).once
      dockup.upload(src)
    end
  end
end
