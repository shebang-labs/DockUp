# frozen_string_literal: true

module Backends
  class S3 < Base
    PREREQUISITES = %i[AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY].freeze

    def upload; end
  end
end
