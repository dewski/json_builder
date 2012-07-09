require 'active_support/notifications'
require 'json_builder/helpers'

module JSONBuilder
  class Partial
    include Helpers

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

    def render
      if collection?
        @object.each do |instance|
          render_layout instance
        end
      else
        render_layout
      end
    end

    def source
      begin
        File.read @path
      rescue Errno::ENOENT
        raise MissingTemplate, "Missing partial #{@path}"
      end
    end

    private

    def instrument(name, options = {})
      ActiveSupport::Notifications.instrument("render_#{name}.action_view", options) { yield }
    end
  end
end
