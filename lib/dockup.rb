# frozen_string_literal: true

class DockUp
  attr_accessor :uploader
  def initialize(uploader)
    @uploader = uploader
    @uploader.verify_prerequisites!
  end

  def upload
    @uploader.upload
  end
end
