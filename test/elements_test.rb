require 'test_helper'

class TestElements < Test::Unit::TestCase
  def assert_elements_equal(value, array)
    assert_equal value, JSONBuilder::Elements.new(nil, array).to_s
  end

  def test_array_hash
    assert_elements_equal '[{"woot":true}]', [{ :woot => true }]
  end

  def test_custom_class_objects
    assert_elements_equal '["olleh", "eybdoog"]', [Dozer.new('hello'), Dozer.new('goodbye')]
  end

  def test_raises_invalid_argument
    assert_raises(JSONBuilder::InvalidArgument) {
      JSONBuilder::Elements.new(nil, false).to_s
    }
  end
end
