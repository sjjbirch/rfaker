

module Rfaker
  # Class for creating and holding collection of weighted faker generators.
  class Compositor
    attr_accessor :input_classes, :input_weights

    def initialize(params = {})
      instance_params = {
        "classes" => "Faker",
        "weights" => "default",
        "tree" => FakerTree.new(Rfaker::Helpers.lazy_path).tree
      }.merge(params)

      @input_classes = instance_params.fetch("classes")
      @input_weights = instance_params.fetch("weights")
      @tree = instance_params.fetch("tree")
      # TODO: This is a placeholder method returning the full tree.
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
end