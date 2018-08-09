# frozen_string_literal: true

class DockUp
  attr_accessor :uploader
  def initialize(uploader)
    @uploader = uploader
  end

  def upload(path)
    @uploader.upload(path)
  end
end
