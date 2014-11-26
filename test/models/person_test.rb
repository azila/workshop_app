require 'test_helper'

class PersonTest < ActiveSupport::TestCase

  def setup
    @person = people(:person_one)
  end

  test "should not save person without first name" do
    @person.first_name = nil
    assert_not @person.valid?
    assert @person.errors.messages.key?(:first_name)
  end

  test "should be valid with all required data" do
    assert @person.valid?
  end

  test "full name" do
    assert_equal "Yukihiro Matsumoto", people(:person_one).full_name
  end

  test "full name without surname" do
    person = people(:person_one)
    person.last_name = nil
    assert_equal "Yukihiro", person.full_name
  end

end
