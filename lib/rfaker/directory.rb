# frozen_string_literal: true

module Rfaker
  #   Helper methods:
  module Helpers
    def self.faker_path
      # Returns path of faker
      `bundle show faker`.delete("\n")
    end

    def self.faker_class_path(base_faker_path)
      "#{base_faker_path}/lib/faker"
    end

    def self.faker_yaml_path(base_faker_path, region = "en")
      "#{base_faker_path}/lib/locales/#{region}" # TODO: Use for direct yaml calls as alt method to method traversal.
    end

    def self.lazy_path
      Rfaker::Helpers.faker_class_path(Rfaker::Helpers.faker_path)
    end
  end
end
