# frozen_string_literal: true

require_relative "rfaker/version"

# This module contains the top level classes for conditional and random faker generator selections.
module Rfaker

  class Error < StandardError; end

  # The class for randomising generator returns
  class Randomiser
    def initialize
      super
    end

    def rd(classes, weights="default")
      puts classes
      puts weights
    end
  end
end

hmm = Rfaker::Randomiser.rd

puts hmm
