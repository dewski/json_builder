require 'action_view/base'
require 'action_view/template'

module ActionView #:nodoc:
  class Base
    cattr_accessor :pretty_print_json
    @@pretty_print_json = false
  end
end

module ActionView
  module Template::Handlers
    class JSONBuilder < Template::Handler
      include Compilable

      self.default_format = Mime::JSON

      def compile(template)
        "json = ::JSONBuilder::Generator.new(:pretty => #{ActionView::Base.pretty_print_json});" +
          template.source +
        ";json.compile!;"
      end
    end
  end
end

ActionView::Template.register_template_handler :json_builder, ActionView::Template::Handlers::JSONBuilder
