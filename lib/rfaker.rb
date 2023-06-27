# frozen_string_literal: true

mydir = __dir__

require "faker"

Dir.glob(File.join(mydir, 'rfaker', '/**/*.rb')).sort.each { |file| require file }

# Module containing methods for selecting generators.
module Rfaker
  class Error < StandardError; end

  # shortform Compositor factory input function
  # Insert Faker domains to composite them with default weights.
  def self.composite(*domains)
    params = { "classes" => domains, "weights" => "default" }
    Rfaker::Compositor.new(params)
  end
end


