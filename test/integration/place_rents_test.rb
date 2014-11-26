require 'test_helper'
require 'capybara/rails'

class PlaceRentsTest < ActionDispatch::IntegrationTest

  def setup
    log_in_user
  end

  def teardown
    log_out_user
  end

  test "user rents a place on a parking" do
    visit '/parkings'
    click_link 'Rent a place', :match => :first

    select('2014', from: 'start_date_year')
    select('February', from: 'start_date_month')
    select('1', from: 'start_date_day')

    select('2014', from: 'end_date_year')
    select('February', from: 'end_date_month')
    select('3', from: 'end_date_day')

    select('Ford', from: 'place_rent_car_id')
    click_button 'Create Place Rent'
    assert has_content? 'Place rent created successfully.'
    assert has_content? 'Start date'
    assert has_content? '2014'
    assert has_content? '02'
    assert has_content? '01'
  end

end
