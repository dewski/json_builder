# encoding: UTF-8

require 'test_helper'

class User
  def to_partial_path
    'users'
  end
end

class TestPartial < Test::Unit::TestCase
  def partial(*args)
    JSONBuilder::Partial.new(*args)
  end

  def test_object_as_first_argument
    assert_kind_of User, partial(User.new).object
  end

  def test_array_of_objects_as_first_argument
    assert_kind_of Array, partial([Hash.new, Hash.new]).object
  end

  def test_partial_file_path_from_model
    assert_equal 'users', partial(User.new).path
  end

  def test_passed_in_partial_path
    assert_equal 'custom/path', partial('custom/path').path
  end

  def test_missing_partial_file
    assert_raise(JSONBuilder::Partial::MissingTemplate) {
      partial('test/me').source
    }
  end
end
