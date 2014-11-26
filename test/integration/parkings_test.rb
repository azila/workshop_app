require 'test_helper'
require 'capybara/rails'

class ParkingsTest < ActionDispatch::IntegrationTest

  def setup
    @parking = parkings(:parking_four)
  end
  
  test "user opens parkings index" do
    visit '/parkings'
    assert has_content? 'Parkings'
  end

  test "user opens parking details" do
    visit parkings_path
    click_link "show_#{@parking.id}"

    assert has_content? 'Show Parking'
    assert has_content? 'Kiev'
    assert has_content? 'Mendelejewa'
    assert has_content? '44-444'
    assert has_content? '12'
    assert has_content? '34'
    assert has_content? '567'
    assert has_content? 'indoor'
  end

  test "user adds a new parking" do
    visit parkings_path
    click_link 'Add New Parking'

    fill_in 'Hour price', with: '9'
    fill_in 'Day price', with: '87'
    fill_in 'Places', with: '654'
    choose('parking_kind_outdoor')
    fill_in 'City', with: 'Warszawa'
    fill_in 'Street', with: 'Nowa'
    fill_in 'Zip code', with: '23-777'
    click_button 'Create Parking'
    assert has_content? 'Parking created successfully.'
    assert has_content? 'Warszawa'
    assert has_content? '9'
    assert has_content? '87'
    assert has_content? '654'
  end

  test "user edits a parking" do
    visit parkings_path
    click_link "edit_#{@parking.id}"

    fill_in 'Hour price', with: '13'
    fill_in 'Day price', with: '44'
    fill_in 'Places', with: '555'
    choose('parking_kind_outdoor')
    fill_in 'City', with: 'Brussels'
    fill_in 'Street', with: 'Le Monde'
    fill_in 'Zip code', with: '23-745'
    click_button 'Update Parking'
    assert has_content? 'Parking updated successfully.'
    assert has_content? 'Brussels'
    assert has_content? 'Le Monde'
    assert has_content? '23-745'
    assert has_content? '13'
    assert has_content? '44'
    assert has_content? '555'
  end

  test "user removes a parking" do
    visit parkings_path
    click_on "delete_#{@parking.id}"
    
    assert has_content? 'Parking deleted successfully.'
    assert has_no_content? 'Kiev'
  end

  test "private parkings scope" do
    assert_equal parkings(:parking_one), Parking.private_parkings.first
  end

  test "public parkings scope" do
    assert_equal 3, Parking.public_parkings.size
  end

  test "day price within range" do
    Parking.day_price_within_range(10,20).each do |parking|
        assert((parking.day_price >= 10) && (parking.day_price <= 20))
    end
  end

  test "hour price within range" do
    Parking.hour_price_within_range(2, 3).each do |parking|
        assert((parking.hour_price >= 2) && (parking.hour_price <= 3))
    end
  end

  test "located in scope" do
    assert_equal parkings(:parking_three), Parking.located_in("Warszawa").first
  end

  test "search form" do
    visit '/parkings'
    check('public')
    fill_in 'day_price_min', with: '10'
    fill_in 'day_price_max', with: '20'
    fill_in 'hour_price_min', with: '1'
    fill_in 'hour_price_max', with: '2'
    fill_in 'location', with: 'Krakow'
    
    click_on 'Search'
    page.has_xpath?('public')
    page.has_xpath?('day_price_min')
    page.has_xpath?('day_price_max')
    page.has_xpath?('hour_price_min')
    page.has_xpath?('hour_price_max')
    page.has_xpath?('location')

    assert has_content? 'Krakow'
  end

  test "search form with public and private parkings" do
    visit '/parkings'
    check('public')
    check('private')
    
    click_on 'Search'
    assert has_content? '100'
    assert has_content? '200'
    assert has_content? '300'
    assert has_content? '567'
  end

end
