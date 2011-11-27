require 'blankslate' unless defined? BlankSlate
require 'json_builder/member'

module JSONBuilder
  class Compiler < BlankSlate
    class << self
      def generate(*args, &block)
        options = args.extract_options!
        compiler = self.new(options)
        compiler.compile(*args, &block)
        compiler.to_s
      end
    end
    
    attr_accessor :members
    attr_accessor :array
    attr_accessor :scope
    attr_accessor :callback
    attr_accessor :pretty_print
    
    def initialize(options={})
      @members = []
      @scope = options[:scope]
      @callback = options[:callback]
      @pretty_print = options[:pretty]
    end
    
    def compile(*args, &block)
      instance_exec(*args, &block)
    end
    
    def array(items, &block)
      @array = Elements.new(items, &block)
    end
    
    # Need to return a Key instance to allow for arrays to be handled appropriately
    def method_missing(key, *args, &block)
      member = Member.new(key, *args, &block)
      @members << member
      member
    end
    alias_method :key, :method_missing
    
    # Once all nodes are compiled, build the string
    def to_s
      include_callback @array ? @array.to_s : "{#{@members.collect(&:to_s).join(', ')}}"
    end
    
    private
    
    def include_callback(json)
      @callback && request_params[:callback] ? "#{request_params[:callback]}(#{pretty_print(json)})" : pretty_print(json)
    end
    
    def pretty_print(json)
      @pretty_print ? JSON.pretty_generate(JSON[json]) : json
    end
    
    def request_params
      @scope.respond_to?(:params) ? @scope.params : {}
    end
  end
end
