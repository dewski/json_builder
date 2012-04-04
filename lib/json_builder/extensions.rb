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
  def to_builder
    %("#{json_escape}")
  end

  private

  def json_escape
    self.gsub(/\n/, '\\n').
         gsub(/\r/, '\\r').
         gsub(/\t/, '\\t').
         gsub(/\f/, '\\f')
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

module BSON
  class ObjectId
    def to_builder
      %("#{self}")
    end
  end
end
