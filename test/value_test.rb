# encoding: UTF-8

require 'test_helper'

class TestValue < Test::Unit::TestCase
  def value(value)
    JSONBuilder::Value.new(nil, value).to_s
  end

  def test_positive_value
    assert_equal '1', value(1)
  end

  def test_negative_value
    assert_equal '-5', value(-5)
  end

  def test_float_value
    assert_equal '13.37', value(13.37)
  end

  def test_nil_value
    assert_equal 'null', value(nil)
  end

  def test_true_value
    assert_equal 'true', value(true)
  end

  def test_false_value
    assert_equal 'false', value(false)
  end

  def test_symbol_value
    assert_equal 'test', value(:test)
  end

  def test_unicode_char_value
    assert_equal '"hellyé"', value('hellyé')
  end

  def test_time_value
    assert_equal '"2012-01-01T00:00:00Z"', value(Time.utc(2012))
  end

  def test_time_with_zone_value
    Time.zone = 'CET'
    assert_equal '"2012-01-01T00:00:00+01:00"', value(Time.zone.local(2012))
  end

  # This will be the local time zone offset, hence the wildcard.
  def test_date_value
    assert_match /"2012-01-01T00:00:00.*/, value(Date.parse('2012-01-01'))
  end

  def test_date_time_value
    assert_equal '"2012-01-01T00:00:00Z"', value(DateTime.parse('2012-01-01'))
  end

  def test_hash_value
    assert_equal '{"oh":"boy"}', value(:oh => :boy)
  end

  def test_custom_class
    assert_equal '"olleh"', value(Dozer.new('hello'))
  end

  def test_double_quoted_value
    assert_equal '"\"hello\""', value('"hello"')
  end
end
