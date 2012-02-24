require 'json_builder/version'
require 'json_builder/compiler'
require 'json_builder/template' if defined? Rails

module JSONBuilder
  class InvalidArgument < StandardError; end
  class MissingKeyError < StandardError; end
end
