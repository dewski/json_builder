require 'active_support/notifications'

module JSONBuilder
  class Partial
    class MissingTemplate < StandardError; end;

    attr_accessor :object
    attr_accessor :options
    attr_accessor :path

    def initialize(*args)
      @options = args.extract_options!
      @object = args.first

      setup @object, @options
    end

    def setup(object, options)
      if (Object.const_defined?('ActiveRecord') && ActiveRecord::Base === object.superclass) || object.respond_to?(:to_partial_path)
        begin
          @path = object.to_partial_path
        rescue
          raise ArgumentError.new("'#{object.inspect}' is not an ActiveModel-compatible object. It must implement :to_partial_path.")
        end
      end

      if String === object
        @path = object
      end
    end

    def source
      instrument :template do
        begin
          File.read @path
        rescue Errno::ENOENT
          raise MissingTemplate
        end
      end
    end

    private

    def instrument(name, options = {})
      ActiveSupport::Notifications.instrument("render_#{name}.action_view", options) { yield }
    end
  end
end
