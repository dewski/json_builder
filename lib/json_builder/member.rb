require 'json_builder/value'
require 'json_builder/elements'

module JSONBuilder
  class Member
    attr_accessor :key
    attr_accessor :value
    
    def initialize(key, *args, &block)
      @key = key

      argument = args.shift
      if argument.is_a?(Array)
        @value = Elements.new(argument, &block)
      else
        @value = Value.new(*argument, &block)
      end
    end
    
    def to_s
      "\"#{@key}\": #{@value}"
    end
  end
end