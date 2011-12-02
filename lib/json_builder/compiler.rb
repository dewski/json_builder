require 'blankslate' unless defined?(BlankSlate)
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
      @_members = []
      @_scope = options[:scope]
      @_callback = options[:callback] || true
      @_pretty_print = options[:pretty] || false
      
      # Only copy instance variables if there is a scope and presence of Rails
      copy_instance_variables_from(@_scope) if @_scope
    end
    
    def compile(*args, &block)
      instance_exec(*args, &block)
    end
    
    def array(items, &block)
      @_array = Elements.new(@_scope, items, &block)
    end
    
    # Need to return a Key instance to allow for arrays to be handled appropriately
    def method_missing(key_name, *args, &block)
      if @_scope.respond_to?(key_name) && !ignore_scope_methods.include?(key_name)
        @_scope.send(key_name, *args, &block)
      else
        key(key_name, *args, &block)
      end
    end
    
    def key(key_name, *args, &block)
      member = Member.new(key_name, @_scope, *args, &block)
      @_members << member
      member
    end
    
    # Once all nodes are compiled, build the string
    def to_s
      include_callback @_array ? @_array.to_s : "{#{@_members.collect(&:to_s).join(', ')}}"
    end
    
    private
    
    def include_callback(json)
      @_callback && request_params[:callback] ? "#{request_params[:callback]}(#{pretty_print(json)})" : pretty_print(json)
    end
    
    def pretty_print(json)
      @_pretty_print ? JSON.pretty_generate(JSON[json]) : json
    end
    
    def request_params
      @_scope.respond_to?(:params) ? @_scope.params : {}
    end
    
    def copy_instance_variables_from(object, exclude = []) #:nodoc:
      vars = object.instance_variables.map(&:to_s) - exclude.map(&:to_s)
      vars.each { |name| instance_variable_set(name, object.instance_variable_get(name)) }
    end
    
    # There are some special methods that need to be ignored that may be matched within +@_scope+.
    def ignore_scope_methods
      [:id]
    end
  end
end
