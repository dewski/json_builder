require 'json_builder/extensions'

module JSONBuilder
  class Value
    attr_accessor :value

    # Public: Creates
    #
    # scope - The view scope context for any variables.
    # arg   - Could be string, hash, or any other Ruby value.
    # block - Yielding any block passed to the element.
    #
    # Returns an instance of JSONBuilder::Member, JSONBuilder::Compiler
    # or String.
    def initialize(scope, arg, &block)
      if block
        @value = Compiler.new(:scope => scope)
        compiled = @value.compile(arg, &block)

        # For the use case that the passed in block returns a non-member object
        # or normal Ruby object
        @value = compiled unless compiled.is_a?(Member)
      else
        @value = arg
      end
    end

    # Public: Determines of the stored value has a special return value
    # or calls the default to_s on it.
    #
    # Returns a String.
    def to_s
      @value.respond_to?(:to_builder) ? @value.to_builder : @value.to_s
    end
  end
end
