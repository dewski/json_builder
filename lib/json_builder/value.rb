require 'active_support/time'

module JSONBuilder
  class Value
    attr_accessor :value
    
    def initialize(*args, &block)
      if block_given?
        @value = Compiler.new
        compiled = @value.compile(*args, &block)
        
        # For the use case that the passed in block returns a non-member object
        # or normal Ruby object
        @value = compiled unless compiled.is_a?(Member)
      elsif args.length == 1
        @value = args.first
      end
    end
    
    # TODO: Complete list of objects
    def to_s
      case @value
      when String, TrueClass, FalseClass then @value.inspect
      when NilClass then 'null'
      when Time, Date, DateTime then @value.iso8601.inspect
      else @value.to_s
      end
    end
  end
end
