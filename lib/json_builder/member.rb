require 'json_builder/value'
require 'json_builder/elements'

module JSONBuilder
  class Member
    attr_accessor :key, :value
    
    def initialize(key, scope, *args, &block)
      raise MissingKeyError if key.nil?
      
      @key = key
      
      argument = args.shift
      if argument.is_a?(Array) || defined?(ActiveRecord::Relation) && argument.is_a?(ActiveRecord::Relation)
        @value = Elements.new(scope, argument, &block)
      else
        @value = Value.new(scope, argument, &block)
      end
    end
    
    def to_s
      "\"#{@key}\": #{@value}"
    end
  end
end