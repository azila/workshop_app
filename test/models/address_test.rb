require 'test_helper'

class AddressTest < ActiveSupport::TestCase

  def setup
    @address = Address.new(city: 'Krakow', street: 'Piekarska', zip_code: '30-234')
  end

  test "should not save address without city" do
  	@address.city = nil
    assert_not @address.valid?
    assert @address.errors.messages.key?(:city)
  end

  test "should not save address without street" do
  	@address.street = nil
    assert_not @address.valid?
    assert @address.errors.messages.key?(:street)
  end

  test "should not save address without zip_code" do
  	@address.zip_code = nil
    assert_not @address.valid?
    assert @address.errors.messages.key?(:zip_code)
  end

  test "should check format of zipcode - test one" do
  	@address.zip_code = "blahblah33-555whatever"
    assert_not @address.valid?
    assert @address.errors.messages.key?(:zip_code)
  end

  test "should check format of zipcode - test two" do
  	@address.zip_code = "55555"
    assert_not @address.valid?
    assert @address.errors.messages.key?(:zip_code)
  end

  test "should be valid with all required data" do
    assert @address.valid?
  end

end

