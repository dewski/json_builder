require 'json_builder/extensions'

module JSONBuilder
  class Value
    attr_accessor :value
    
    def initialize(scope, arg, &block)
      if block_given?
        @value = Compiler.new(:scope => scope)
        compiled = @value.compile(arg, &block)
        
        # For the use case that the passed in block returns a non-member object
        # or normal Ruby object
        @value = compiled unless compiled.is_a?(Member)
      else
        @value = arg
      end
    end
    
    def to_s
      @value.respond_to?(:to_builder) ? @value.to_builder : @value.to_s
    end
  end
end
