require 'active_support/all'

class Object
	def to_builder(scope=nil)
		to_s
	end
end

class FalseClass
  def to_builder(scope)
    'false'
  end
end

class TrueClass
  def to_builder(scope)
    'true'
  end
end

class String
  JS_ESCAPE_MAP = {
    '\\'    => '\\\\',
    '</'    => '<\/',
    "\r\n"  => '\n',
    "\n"    => '\n',
    "\r"    => '\n',
    '"'     => '\\"',
    "'"     => "\\'"
  }

  def to_builder(scope)
    %("#{json_escape}")
  end

  private

  def json_escape
    gsub(/(\\|<\/|\r\n|\342\200\250|\342\200\251|[\n\r"'])/u) { |match|
      JS_ESCAPE_MAP[match]
    }
  end
end

class Hash
  def to_builder(scope)
    to_json
  end
end

class NilClass
  def to_builder(scope)
    'null'
  end
end

module ActiveSupport
  class TimeWithZone
    def to_builder(scope)
      %("#{iso8601}")
    end
  end
end

class Time
  def to_builder(scope)
    %("#{iso8601}")
  end
end

class Date
  def to_builder(scope)
    %("#{to_time.iso8601}")
  end
end

class DateTime
  def to_builder(scope)
    %("#{to_time.iso8601}")
  end
end

module BSON
  class ObjectId
    def to_builder(scope)
      %("#{self}")
    end
  end
end

module ActiveRecord
  class Base
    def to_builder(scope)
      path = "#{Rails.root}/app/views/#{self.to_partial_path}.json.json_builder"
      @object = self
      json = JSONBuilder::Compiler.new(:scope => scope)
      json.compile do
        json.instance_eval(File.read(path))
      end
      json.finalize
    end
  end
end