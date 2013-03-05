require 'rubygems'
require 'bundler'
Bundler.setup(:default, :test)
Bundler.require(:default, :test)

require 'coveralls'
Coveralls.wear!

dir = File.dirname(File.expand_path(__FILE__))
$LOAD_PATH.unshift dir + '/../lib'
$TESTING = true
require 'test/unit'
require 'json_builder'
require 'tzinfo'

class Dozer
  attr_accessor :value

  def initialize(value)
    @value = value
  end

  def to_builder
    @value.reverse.inspect
  end
end
