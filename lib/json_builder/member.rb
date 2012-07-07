require 'json_builder/value'
require 'json_builder/elements'

module JSONBuilder
  class Member
    attr_accessor :key, :value

    # Public: Returns a key value pair for the stored value which could
    # be an instance of JSONBuilder::Elements or JSONBuilder::Value.
    #
    # key   - Used to generate the JSON member's key. Can be a String or Symbol.
    # scope - The view scope context for any variables.
    # args  - Can be an Array or other standard Ruby value.
    # block - Yielding any block passed to the element.
    #
    # Raises JSONBuilder::MissingKeyError if the key passed is nil.
    # Returns instance of JSONBuilder::Member.
    def initialize(scope, key, *args, &block)
      raise MissingKeyError if key.nil?

      @key = key

      argument = args.shift
      if argument.is_a?(Array) || defined?(ActiveRecord::Relation) && argument.is_a?(ActiveRecord::Relation)
        @value = Elements.new(scope, argument, &block)
      else
        @value = Value.new(scope, argument, &block)
      end
    end

    # Public: Returns a key value pair for the stored value which could
    # be an instance of JSONBuilder::Elements or JSONBuilder::Value.
    #
    # Returns a String.
    def to_s
      "\"#{@key}\": #{@value}"
    end
  end
end