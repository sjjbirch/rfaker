# frozen_string_literal: true

# The part of the module that contains the FakerTree class
module Rfaker
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

end