require 'test_helper'

class CarTest < ActiveSupport::TestCase
  def setup
    @car = Car.new(registration_number: '65HHJGG', model: 'BMW', owner_id: '1')
  end

  test "should not save car without registration number" do
  	@car.registration_number = nil
    assert_not @car.valid?
    assert @car.errors.messages.key?(:registration_number)
  end

  test "should not save car without model" do
  	@car.model = nil
    assert_not @car.valid?
    assert @car.errors.messages.key?(:model)
  end

  test "should not save car without owner id" do
  	@car.owner_id = nil
    assert_not @car.valid?
    assert @car.errors.messages.key?(:owner)
  end

  test "should be valid with all required data" do
    @car.owner = Person.new(first_name: 'Liza', last_name: 'Korotchenko')
    assert @car.valid?
  end

end

