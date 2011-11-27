require 'blankslate' unless defined? BlankSlate
require 'json_builder/member'

module JSONBuilder
  class Compiler < BlankSlate
    attr_accessor :members
    attr_accessor :compiled
    
    def initialize
      @members = []
    end
    
    def compile(*args, &block)
      instance_exec(*args, &block)
    end
    
    # Need to return a Key instance to allow for arrays to be handled appropriately
    def method_missing(key, *args, &block)
      member = Member.new(key, *args, &block)
      @members << member
      member
    end
    
    # Once all nodes are compiled, build the string
    def to_s
      "{#{@members.collect(&:to_s).join(', ')}}"
    end
  end
end
