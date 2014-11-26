require 'test_helper'

class ParkingTest < ActiveSupport::TestCase

  def setup
    @parking = Parking.new(hour_price: '10', day_price: '20', places: '100', kind: 'street' )
  end

  test "should not save parking without places" do
  	@parking.places = nil
    assert_not @parking.valid?
    assert @parking.errors.messages.key?(:places)
  end

  test "should not save parking without day price" do
  	@parking.day_price = nil
    assert_not @parking.valid?
    assert @parking.errors.messages.key?(:day_price)
  end

  test "should not save parking without hour price" do
  	@parking.hour_price = nil
    assert_not @parking.valid?
    assert @parking.errors.messages.key?(:hour_price)
  end

  test "should not save parking if kind is wrong" do
  	@parking.kind = "aaaaa"
    assert_not @parking.valid?
    assert @parking.errors.messages.key?(:kind)
  end

  test "should check if hour price is numerical" do
    @parking.hour_price = "12ddd"
    assert_not @parking.valid?
    assert @parking.errors.messages.key?(:hour_price)
  end

  test "should check if day price is numerical" do
    @parking.day_price = "12ddd"
    assert_not @parking.valid?
    assert @parking.errors.messages.key?(:day_price)
  end

  test "should be valid with all required data" do
    assert @parking.valid?
  end

  test "should check if places is numerical" do
    @parking.places = "fff111"
    assert_not @parking.valid?
    assert @parking.errors.messages.key?(:places)
  end

  test "should check if places is greater than 0" do
    @parking.places = "-8"
    assert_not @parking.valid?
    assert @parking.errors.messages.key?(:places)
  end

  test "should check if day price is greater than 0" do
    @parking.day_price = "-1"
    assert_not @parking.valid?
    assert @parking.errors.messages.key?(:day_price)
  end

  test "should check if hour price is greater than 0" do
    @parking.hour_price = "-5"
    assert_not @parking.valid?
    assert @parking.errors.messages.key?(:hour_price)
  end

end
