require 'json'
require 'json_builder/helpers'
require 'json_builder/member'
require 'json_builder/partial'

module JSONBuilder
  class Compiler
    include Helpers

    class << self
      # Public: The helper that builds the JSON structure by calling the
      # specific methods needed to build the JSON.
      #
      # args  - Any number of arguments needed for the JSONBuilder::Compiler.
      # block - Yielding a block to generate the JSON.
      #
      # Returns a String.
      def generate(*args, &block)
        options = args.extract_options!
        compiler = self.new(options)
        compiler.compile(*args, &block)
        compiler.finalize
      end
    end

    attr_accessor :members
    attr_accessor :array
    attr_accessor :scope
    attr_accessor :callback
    attr_accessor :pretty_print

    # Needed to allow for the id key to be used
    undef_method :id if methods.include? 'id'

    # Public: Creates a new Compiler instance used to hold any and
    # all JSONBuilder::Member objects.
    #
    # options - Hash of options used to modify JSON output.
    #
    # Examples
    #
    #   json = JSONBuilder::Compiler.new(:callback => false)
    #   json.compile do
    #     name 'Garrett'
    #   end
    #   json.finalize
    #   # => {"name": "Garrett"}
    #
    # Returns instance of JSONBuilder::Compiler.
    def initialize(options={})
      @_members = []
      @_scope = options.fetch(:scope, nil)
      @_callback = options.fetch(:callback, true)
      @_pretty_print = options.fetch(:pretty, false)

      # Only copy instance variables if there is a scope and presence of Rails
      copy_instance_variables_from(@_scope) if @_scope
    end

    # Public: Takes a block to generate the JSON structure by calling method_missing
    # on all members passed to it through the block.
    #
    # args     - An array of values passed to JSONBuilder::Value.
    # block    - Yielding a block to generate the JSON.
    #
    # Returns nothing.
    def compile(*args, &block)
      instance_exec(*args, &block)
    end

    # Public: Takes a set number of items to generate a plain JSON array response.
    #
    # Returns instance of JSONBuilder::Elements.
    def array(items, &block)
      @_array = Elements.new(@_scope, items, &block)
    end

    # Public: Executes an extracted bit of JSONBuilder view code on the parent
    # JSONBuilder::Compiler object.
    #
    # args - could be string or options
    #
    # Returns nothing.
    def partial(*args)
      Partial.render(self, *args)
    end

    # Public: Called anytime the compiler is passed JSON keys,
    # first checks to see if the parent object contains the method like
    # a Rails helper.
    #
    # key_name - The key for the JSON member.
    # args     - An array of values passed to JSONBuilder::Value.
    # block    - Yielding any block passed to the element.
    #
    # Returns nothing.
    def method_missing(key_name, *args, &block)
      if @_scope.respond_to?(key_name) && !ignore_scope_methods.include?(key_name)
        @_scope.send(key_name, *args, &block)
      else
        key(key_name, *args, &block)
      end
    end

    # Public: Generates the start of the JSON member. Useful if the key you are
    # generating is dynamic.
    #
    # key   - Used to generate the JSON member's key. Can be a String or Symbol.
    # args  - An array of values passed to JSONBuilder::Value.
    # block - Yielding any block passed to the element.
    #
    # Examples
    #
    #   key :hello, 'Hi'
    #   # => "hello": "Hi"
    #
    #   key "item-#{rand(0, 500)}", "I'm random!"
    #   # => "item-250": "I'm random!"
    #
    # Returns instance of JSONBuilder::Member.
    def key(key_name, *args, &block)
      member = Member.new(@_scope, key_name, *args, &block)
      @_members << member
      member
    end

    # Public: Combines the output of the compiled members and the change
    # there is a JSONP callback. This is what is returned in the response.
    #
    # Returns a String.
    def finalize
      include_callback to_s
    end

    # Public: Gathers the JSON structure and calls it's compiler within each
    # instance.
    #
    # Returns a String.
    def to_s
      @_array ? @_array.to_s : "{#{@_members.collect(&:to_s).join(', ')}}"
    end

    private

    # Private: Determines whether or not to include a JSONP callback in
    # the response.
    #
    # json - The String representation of the JSON structure.
    #
    # Returns a String.
    def include_callback(json)
      @_callback && request_params[:callback] ? "#{request_params[:callback]}(#{pretty_print(json)})" : pretty_print(json)
    end

    # Private: Determines whether or not to pass the string through the a
    # JSON prettifier to help with debugging.
    #
    # json - The String representation of the JSON structure.
    #
    # Returns a String.
    def pretty_print(json)
      @_pretty_print ? JSON.pretty_generate(JSON[json]) : json
    end

    # Private: Contains the params from the request.
    #
    # Returns a Hash.
    def request_params
      @_scope.respond_to?(:params) ? @_scope.params : {}
    end

    # Private: Array of instance variable names that should not be set for
    # the scope.
    #
    # Returns an Array of Symbols.
    def ignore_scope_methods
      [:id]
    end
  end
end
