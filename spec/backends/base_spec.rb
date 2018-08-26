# frozen_string_literal: true

describe Backends::Base do
  subject { Backends::Base.new }
  let(:prerequisites) { ['DockUpBackend'] }

  before(:each) do
    stub_const('Backends::Base::PREREQUISITES', prerequisites)
  end

  describe '#initialize' do
    let(:prerequisites) { ['FakePrerequisite'] }
    it 'should call verify_prerequisites! once' do
      expect_any_instance_of(Backends::Base).to(
        receive(:verify_prerequisites!).once.and_return(false)
      )
      subject
    end
  end

  describe '#verify_prerequisites!' do
    context 'prerequisites is satisfied' do
      it 'should pass and not raise any errors' do
        expect { subject }.not_to raise_error
      end
    end
    context 'prerequisites is not satisfied' do
      let(:prerequisites) { ['FakePrerequisite'] }
      it 'should raise MissingPrerequisitesError' do
        expect { subject }.to raise_error(MissingPrerequisitesError)
      end
    end
  end

  describe '#entries' do
    context 'path is a directory' do
      let(:path) { './spec/fixtures/folder_to_upload' }
      it 'should return list of sub dirs and files' do
        result = subject.send(:entries, path)
        expect(result).to be_an(Array)
        expect(result).to match_array(
          [
            './spec/fixtures/folder_to_upload/sub_folder',
            './spec/fixtures/folder_to_upload/file_to_upload.txt',
            './spec/fixtures/folder_to_upload/file_to_upload_2.txt'
          ]
        )
      end
    end
    context 'path is a file' do
      let(:path) { './spec/fixtures/folder_to_upload/file_to_upload.txt' }
      it 'should return the file path an an array' do
        result = subject.send(:entries, path)
        expect(result).to be_an(Array)
        expect(result).to match_array(
          ['./spec/fixtures/folder_to_upload/file_to_upload.txt']
        )
      end
    end
  end

  describe '#prerequisites?' do
    context 'prerequisites is satisfied' do
      it 'should return true' do
        expect(subject.send(:prerequisites?)).to be_truthy
      end
    end
    context 'prerequisites is satisfied' do
      let(:prerequisites) { ['FakePrerequisite'] }
      it 'should return false' do
        expect { subject }.to raise_error(MissingPrerequisitesError)
        allow_any_instance_of(Backends::Base).to receive(:verify_prerequisites!)
        expect(subject.send(:prerequisites?)).to be_falsy
      end
    end
  end

  describe '#upload' do
    it 'should upload 2 files' do
      allow_any_instance_of(subject.class).to receive(:upload_file)
      path = './spec/fixtures/folder_to_upload'
      expect(subject).to receive(:upload_file).twice
      result = subject.upload(path)
      expect(result).to be_an(Array)
      expect(result).to match_array(
        [
          'spec/fixtures/folder_to_upload/sub_folder',
          'spec/fixtures/folder_to_upload/file_to_upload.txt',
          'spec/fixtures/folder_to_upload/file_to_upload_2.txt'
        ]
      )
    end
  end

  describe '#upload_file' do
    it 'should raise NotImplementedError' do
      expect { subject.upload_file('') }.to raise_error(NotImplementedError)
    end
  end
end
