# frozen_string_literal: true

module Backends
  class Base
    def verify_prerequisites!
      err = "S3 backend expects #{self.class::PREREQUISITES.join(', ')} \
as environment variables"
      raise(MissingPrerequisitesError, err) unless prerequisites?
    end

    private

    def prerequisites?
      self.class::PREREQUISITES.all? do |prereq|
        ENV[prereq.to_s]
      end
    end
  end
end
