require 'active_support/all'

class FalseClass
  def to_builder
    inspect
  end
end

class TrueClass
  def to_builder
    inspect
  end
end

class String
  def to_builder
    inspect
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
      iso8601.inspect
    end
  end
end

class Time
  def to_builder
    iso8601.inspect
  end
end

class Date
  def to_builder
    to_time.iso8601.inspect
  end
end

class DateTime
  def to_builder
    to_time.iso8601.inspect
  end
end

module BSON
  class ObjectId
    def to_builder
      to_s.inspect
    end
  end
end
