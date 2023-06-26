# frozen_string_literal: true

require_relative "rfaker/version"
require "faker"

# The module containing methods for selecting generators.
module Rfaker
  class Error < StandardError; end

  # A class that stores a hash containing the directory of faker classes and methods underneath it
  class FakerTree
    attr_accessor :tree

    # TODO: Create subtrees instead of full trees (already does, just handle args in and out better).
    def initialize(faker_class_path)
      @tree = directory_hash(faker_class_path)
    end

    # Take a directory path as string
    # Return a hash containing the directory of classes and methods underneath it

    def directory_hash(path, name = nil)
      data = { "data" => (name || path) }
      data[:children] = children = []
      directory_hash_iterator(path, children, name)
      data
    end

    def directory_hash_iterator(path, children, name)
      Dir.foreach(path) do |entry|
        next if %w[.. .].include?(entry)

        full_path = File.join(path, entry)
        children << if File.directory?(full_path)
                      directory_hash(full_path, entry)
                    else
                      call, methods = enumerate_fclass_methods(entry, name)
                      Hash[call, methods]
                    end
      end
    end

    # Input class and its parent
    # return array with full call path string and methods array
    def enumerate_fclass_methods(file_name, parent_name)
      return if parent_name.nil?

      no_rb = camelise(file_name.delete_suffix(".rb"))
      parent_name = camelise(parent_name)
      rtn_str = build_full_call(no_rb, parent_name)

      methods = method_adder(rtn_str)

      [rtn_str, methods]
    end

    def method_adder(in_str)
      begin
        methods = arity_pruned_meth_adder(in_str)
      rescue NameError
        methods = arity_pruned_meth_adder(call_fixer(in_str))
      end
      methods
    end

    def arity_pruned_meth_adder(in_str)
      # returns array of methods in class that don't require args
      candidates = eval(in_str).methods(false)
      methods = []
      candidates.each do |candidate|
        # Another fantastic guard clause.
        next if candidate.to_s == "saint_saens"

        meth = eval("#{in_str}.method(candidate)")
        meth.arity.between?(-1, 0) ? methods << meth : next
      end
      methods
    end

    def camelise(string)
      string.split("_").map(&:capitalize).join("")
    end

    def call_fixer(attempted_call)
      arbitrary_substitutions.each_pair do |k, p|
        if attempted_call =~ /#{Regexp.quote(k)}/
          attempted_call[k] = p
          break
        end
      end
      attempted_call
    end

    def arbitrary_substitutions
      {
        "FullmetalAlchemist" => "Fma",
        "Dnd" => "DnD",
        "Music::Show" => "Show",
        "Nhs" => "NationalHealthService",
        "IdNum" => "IDNum",
        "InternetHttp" => "Internet::HTTP",
        "TheItCrowd" => "TheITCrowd",
        "::Room" => "::TheRoom"
      }
    end

    def build_full_call(child_name, parent_name)
      if parent_name.start_with?(child_name) || parent_name == "Default" || parent_name == "Locations"
        "Faker::#{child_name}"
      else
        "Faker::#{parent_name}::#{child_name}"
      end
    end
  end

  # Class for creating and holding collection of weighted faker generators.
  class Randomiser
    attr_accessor :input_classes, :input_weights

    def initialize(params = {})
      @input_classes = params.fetch("classes")
      @input_weights = params.fetch("weights")
      @tree = FakerTree.new(Rfaker::Helpers.lazy_path).tree
    end

    # TODO: Writing these cases made me realise there are two domains for the randomness,
    #       and the input args should probably reflect that:
    #           First domain: The domains for the randomness.
    #           Second domain: The weights of the randomness.
    # Take classes and weights. (take class methods and weights)
    # Return weights as array of numbers with values determined by strings and length equal to classes.
    # If invalid string, use default weight.
    def parse_weight_strings(classes, weights)
      rtn_array = []
      case weights
      when "default"
        # Even at provided arg level, ie class_weight = 1/number_of_called_classes
        rtn_array = apply_default_weights(classes, rtn_array)
      when "return_method_weighted_default"
        # Even at return method weight level, ie class_weight = own_method_pool/total_method_pool
        # TODO: This.
      when "return_entropy_weighted_default"
        # Even at return entry weight level, ie class_weight = own_string_pool/call_string_pool
        # TODO: This.
      else
        # TODO: This.
        "Mission over, we'll get 'em next time."
      end
      rtn_array
    end

    def apply_default_weights(classes, rtn_array)
      classes.length.times do
        rtn_array << 1
      end
      rtn_array
    end
  end

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
