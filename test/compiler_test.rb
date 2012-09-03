# encoding: UTF-8

require 'test_helper'
require 'active_support/ordered_hash'

class TestCompiler < Test::Unit::TestCase
  def assert_builder_json(json, *args, &block)
    assert_equal json, JSONBuilder::Compiler.generate(*args, &block)
  end

  def test_without_nesting
    assert_builder_json('{"name": "Garrett Bjerkhoel", "valid": true}') do
      def valid?
        true
      end

      name 'Garrett Bjerkhoel'
      valid valid?
    end
  end

  def test_support_all_dates
    actual = JSONBuilder::Compiler.generate do
      date Date.new(2011, 11, 23)
      date_time DateTime.new(2001, 2, 3, 4, 5, 6)
      timed Time.utc(2012)
      Time.zone = "CET"
      zoned Time.zone.local(2012)
    end
    # The date will have the local time zone offset, hence the wildcard.
    assert_match(%r{\{"date": "2011-11-23T00:00:00.*", "date_time": "2001-02-03T04:05:06Z", "timed": "2012-01-01T00:00:00Z", "zoned": "2012-01-01T00:00:00\+01:00"\}}, actual)
  end

  def test_should_support_all_datatypes
    assert_builder_json('{"integer": 1, "mega_integer": 100000000, "float": 13.37, "true_class": true, "false_class": false, "missing_nil": null}') do
      integer 1
      mega_integer 100_000_000
      float 13.37
      true_class true
      false_class false
      missing_nil
    end
  end

  def test_should_support_multiple_nestings
    assert_builder_json('{"u": [{"id": 1, "l": [{"l": 1, "d": "t"}, {"l": 2, "d": "tt"}]}, {"id": 2, "l": [{"l": 2, "d": "t"}, {"l": 4, "d": "tt"}]}]}') do
      u [1, 2] do |i|
        id i
        l [1, 2] do |b|
          l b * i
          d 't' do |c|
            c * b
          end
        end
      end
    end
  end

  def test_support_custom_key_names
    assert_builder_json('{"custom_key": 1, "with_method": "nope", "as_string": true, "nested": {"deep_down": -1, "custom": true}, "nope": "chuck"}') do
      def with_method
        "nope"
      end

      key :custom_key, 1
      key :with_method, with_method
      key 'as_string', true
      nested do
        def custom
          'custom'
        end

        key 'deep_down', -1
        key custom, true
      end
      key with_method, 'chuck'
    end
  end

  def test_support_custom_classes
    assert_builder_json('{"hello": "olleh"}') do
      hello Dozer.new('hello')
    end
  end

  def test_adding_hash_objects
    assert_builder_json('{"hash_test": {"garrett":true}}') do
      hash_test :garrett => true
    end
  end

  def test_adding_unicoded_key
    assert_builder_json('{"é": "json"}') do
      key 'é', 'json'
    end
  end

  def test_newline_characters
    assert_builder_json('{"newline": "hello\nworld"}') do
      newline "hello\nworld"
    end
  end

  def test_tab_characters
    assert_builder_json('{"tab": "hello\tworld"}') do
      tab "hello\tworld"
    end
  end
end
