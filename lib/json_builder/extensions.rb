require 'active_support/all'

class FalseClass
  def to_builder
    'false'
  end
end

class TrueClass
  def to_builder
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
    "\t"    => '\t',
    '"'     => '\\"',
    "'"     => "\'"
  }

  def to_builder
    %("#{json_escape}")
  end

  private

  def json_escape
    gsub(/(\\|<\/|\r\n|\342\200\250|\342\200\251|[\t\n\r"'])/u) { |match|
      JS_ESCAPE_MAP[match]
    }
  end
end

class Hash
  def to_builder
    to_json
  end
end

class NilClass
  def to_builder
    'null'
  end
end

module ActiveSupport
  class TimeWithZone
    def to_builder
      %("#{iso8601}")
    end
  end
end

class Time
  def to_builder
    %("#{iso8601}")
  end
end

class Date
  def to_builder
    %("#{to_time.iso8601}")
  end
end

class DateTime
  def to_builder
    %("#{to_time.iso8601}")
  end
end

# Mongoid < 3.0.0
module BSON
  class ObjectId
    def to_builder
      %("#{self}")
    end
  end
end

# Mongoid >= 3.0.0
module Moped
  module BSON
    class ObjectId
      def to_builder
        %("#{self}")
      end
    end
  end
end
