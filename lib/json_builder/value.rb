require 'active_support/time'

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
      case @value
      when String, TrueClass, FalseClass then @value.inspect
      when Hash then @value.to_json
      when NilClass then 'null'
      when Time, Date, DateTime then @value.iso8601.inspect
      else @value.to_s
      end
    end
  end
end
