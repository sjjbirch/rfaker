# frozen_string_literal: true

require_relative "rfaker/version"
require 'faker'

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
      data = { data: (name || path) }
      data[:children] = children = []
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
      data
    end

    # Input class and its parent
    # return array with full call path string and methods array
    def enumerate_fclass_methods(file_name, parent_name)
      return if parent_name.nil?

      no_rb = capitalize_and_underscore_strip(file_name.delete_suffix(".rb"))
      parent_name = capitalize_and_underscore_strip(parent_name)
      rtn_str = build_full_call(no_rb, parent_name)

      begin
        methods = eval(rtn_str).methods(false)
      rescue NameError
        methods = eval(stupid_substitutions(rtn_str)).methods(false)
      end

      [rtn_str, methods]

    end

    def capitalize_and_underscore_strip(string)
      string.split("_").map(&:capitalize).join("")
    end

    def stupid_substitutions(attempted_call)
      case attempted_call
      when /FullmetalAlchemist/
        attempted_call["FullmetalAlchemist"] = "Fma"
      when /Dnd/
        attempted_call["Dnd"] = "DnD"
      when /Music::Show/
        attempted_call["Music::Show"] = "Show"
      when /Nhs/
        attempted_call["Nhs"] = "NationalHealthService" # A bong caused this hack.
      when /IdNum/
        attempted_call["IdNum"] = "IDNum"
      when /InternetHttp/
        attempted_call["InternetHttp"] = "Internet::HTTP"
      when /TheItCrowd/
        attempted_call["TheItCrowd"] = "TheITCrowd"
      when /::Room/
        attempted_call["::Room"] = "::TheRoom"
      end
      attempted_call
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
    attr_accessor :input_classes, :input_weights, :classes, :weights

    def initialize(params = {})
      @input_classes = classes
      @input_weights = weights
      @tree = FakerTree.new(Rfaker::Helpers.lazy_path).tree

      compute_collection

    end

  end

  def parse_weight_strings(classes, weights)
    # Take classes and weights. (take class methods and weights)
    # Return weights as array of numbers with values determined by strings and length equal to classes.
    # If invalid string, use default weight.
    rtn_array = []
    case weights
      # TODO: Writing these cases made me realise there are two domains for the randomness, and the input args should probs reflect:
      #   First domain: The domains for the randomness.
      #   Second domain: The weights of the randomness.
    when "default"
      # Even at provided arg level, ie class_weight = 1/number_of_called_classes
      classes.length.times do rtn_array << 1
      end
    when "return_method_weighted_default"
      # Even at return method weight level, ie class_weight = own_method_pool/total_method_pool
      # TODO: This.
    when "return_entropy_weighted_default"
      # Even at return entry weight level, ie class_weight = own_string_pool/call_string_pool
      # TODO: This.
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
