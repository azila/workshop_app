require 'test_helper'

class PlaceRentTest < ActiveSupport::TestCase

  def setup
    @place_rent = PlaceRent.new(start_date: '2014-11-05 12:30:25', end_date: '2014-11-07 12:30:25', price: '333')
    @place_rent.parking = Parking.new(hour_price: '10', day_price: '20', places: '100', kind: 'street' )
    @place_rent.car = Car.new(registration_number: '65HHJGG', model: 'BMW', owner_id: '1')
  end

  test "should not save place rent without start date" do
    @place_rent.start_date = nil
    assert_not @place_rent.valid?
    assert @place_rent.errors.messages.key?(:start_date)
  end

  test "should not save place rent without end date" do
    @place_rent.end_date = nil
    assert_not @place_rent.valid?
    assert @place_rent.errors.messages.key?(:end_date)
  end

  test "should not save place rent without parking id" do
    @place_rent.parking = nil
    assert_not @place_rent.valid?
    assert @place_rent.errors.messages.key?(:parking)
  end

  test "should not save place rent without car id" do
    @place_rent.car = nil
    assert_not @place_rent.valid?
    assert @place_rent.errors.messages.key?(:car)
  end

  test "should be valid with all required data" do
    assert @place_rent.valid?
  end

  test "indentifier should be unique" do
    rent = PlaceRent.create(start_date: DateTime.now, end_date: 2.days.from_now, car: cars(:car_one), parking: parkings(:parking_one))
    assert_equal 1, PlaceRent.where(identifier: rent.identifier).length
  end

  test "find record by identifier" do
    rent = PlaceRent.create(start_date: DateTime.now, end_date: 2.days.from_now, car: cars(:car_one), parking: parkings(:parking_one))
    assert_equal rent, PlaceRent.find_by!(identifier: rent.identifier) 
  end

  test "all place rents are finished before parking is removed" do
    parkings(:parking_two).destroy
    assert place_rents(:rent_two).end_date < DateTime.now
  end

  test "calculate price before save" do
    new_rent = PlaceRent.create(start_date: "2014-11-01 09:00:00", end_date: "2014-11-03 11:00:00", 
      car: cars(:car_one), parking: parkings(:parking_one))
    assert_equal(10 * 2 + 1 * 2, new_rent.price)
  end

end

