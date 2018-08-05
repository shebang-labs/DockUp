# frozen_string_literal: true

require './autoload'

UPLOADERS_WHITELIST = %i[S3 AzureBlobStorage GoogleCloudStorage].freeze

task :default do
  backend = ENV.fetch('DockUpBackend', 's3')
               .split('_')
               .collect(&:capitalize).join
  unless UPLOADERS_WHITELIST.include?(backend.to_sym)
    raise(InvalidUploaderError, "#{backend} is invalid uploader")
  end
  puts "Selected backup backend is: #{backend}"
  uploader = Object.const_get("Backends::#{backend}").new
  DockUp.new(uploader).upload
end
