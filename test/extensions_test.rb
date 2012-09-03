require 'test_helper'

class TestExtensions < Test::Unit::TestCase
  def test_string_respond_to
    assert_respond_to 'json_builder', :to_builder
  end

  def test_ordered_hash
    assert_respond_to ActiveSupport::OrderedHash.new(:json_builder => true), :to_builder
  end

  def test_true_value
    assert_respond_to true, :to_builder
  end

  def test_false_value
    assert_respond_to false, :to_builder
  end

  def test_hash_value
    assert_respond_to({ :json_builder => true }, :to_builder)
  end

  def test_nil_value
    assert_respond_to nil, :to_builder
  end

  def test_time_with_zone_value
    assert_respond_to Time.zone.now, :to_builder
  end

  def test_time_value
    assert_respond_to Time.utc(2012), :to_builder
  end

  def test_date_value
    assert_respond_to Date.parse('2012-01-01'), :to_builder
  end

  def test_datetime_value
    assert_respond_to DateTime.parse('2012-01-01'), :to_builder
  end

  def test_bson_objectid_value
    assert_respond_to BSON::ObjectId.new, :to_builder
  end

  def test_moped_bson_objectid_value
    assert_respond_to Moped::BSON::ObjectId.new, :to_builder
  end

  def test_custom_class
    assert_respond_to Dozer.new('hello'), :to_builder
  end
end
