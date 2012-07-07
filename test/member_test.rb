# encoding: UTF-8

require 'test_helper'

class TestMember < Test::Unit::TestCase
  def member(key, value=nil, &block)
    JSONBuilder::Member.new(nil, key, value, &block)
  end

  def test_is_a_builder_value
    assert_equal JSONBuilder::Member, member(:hello, true).class
  end

  def test_key_as_symbol
    assert_equal '"hello": true', member(:hello, true).to_s
  end

  def test_key_as_unicoded_symbol
    assert_equal '"hellyé": true', member('hellyé', true).to_s
  end

  def test_key_as_string
    assert_equal '"hello": true', member('hello', true).to_s
  end

  def test_value_as_array
    assert_equal '"hello": [{"ruby":true}]', member('hello', [{ :ruby => true }]).to_s
  end

  def test_value_as_block
    assert_equal '"hello": "hi"', member('hello') { 'hi' }.to_s
  end

  def test_value_as_block_with_hash
    assert_equal '"hello": {"ruby":true}', member('hello') { { :ruby => true } }.to_s
  end

  def test_custom_class
    assert_equal '"hello": "olleh"', member('hello', Dozer.new('hello')).to_s
  end

  def test_double_quoted_value
    assert_equal '"hello": "\"Hello\" he said"', member('hello', '"Hello" he said').to_s
  end

  def test_single_quoted_value
    assert_equal %Q("hello": "hello 'test'!"), member('hello', "hello 'test'!").to_s
  end

  def test_without_key
    assert_raises(JSONBuilder::MissingKeyError) { member(nil, true).to_s }
  end
end
