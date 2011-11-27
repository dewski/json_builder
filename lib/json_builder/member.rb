require 'json_builder/value'
require 'json_builder/elements'

module JSONBuilder
  class Member
    attr_accessor :key
    attr_accessor :value
    
    def initialize(key, *args, &block)
      @key = key
      @value = Value.new(*args, &block)
    end
    
    def to_s
      "\"#{@key}\": #{@value}"
    end
    
    def array(items, &block)
      @value = Elements.new(items, &block)
    end
  end
end