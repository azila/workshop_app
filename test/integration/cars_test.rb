require 'test_helper'
require 'capybara/rails'

class CarsTest < ActionDispatch::IntegrationTest

  def setup
    log_in_user
    @car = cars(:car_two)
  end

  def teardown
    log_out_user
  end
  
  test "user opens cars index" do
    visit '/cars'
    assert has_content? 'Cars'
  end

  test "user opens car details" do
    visit cars_path
    click_link "show_#{@car.id}"

    assert has_content? 'Show Car'
    assert has_content? 'UIU88999'
    assert has_content? 'Ford'
  end

  test "user adds a new car" do
    visit cars_path
    click_link 'Add New Car'

    fill_in 'car_model', with: 'Fiat'
    fill_in 'car_registration_number', with: '55TGFTG'
    click_button 'Create Car'
    assert has_content? 'Car created successfully.'
    assert has_content? 'Fiat'
    assert has_content? '55TGFTG'
  end

  test "user edits a car" do
    visit cars_path
    click_link "edit_#{@car.id}"

    fill_in 'car_model', with: 'Porsche'
    fill_in 'car_registration_number', with: '66HHHHH'   
    click_button 'Update Car'
    assert has_content? 'Car updated successfully.'
    assert has_content? 'Porsche'
    assert has_content? '66HHHHH'
  end

  test "user removes a car" do
    visit cars_path
    click_link "delete_#{@car.id}"
    assert has_content? 'Car deleted successfully.'
    assert has_no_content? 'UIU88999'
    assert has_no_content? 'Ford'
  end

  test "user adds car image" do
    visit cars_path
    click_link "edit_#{@car.id}"
    file_path = Rails.root + "test/fixtures/red_car.png"
    attach_file('car_image', file_path)
    click_button 'Update Car'
    assert has_content? 'Car updated successfully.'
    assert has_content? 'UIU88999'
    assert has_content? 'Ford'
  end

  test "user adds car image that it too big" do
    visit cars_path
    click_link "edit_#{@car.id}"
    file_path = Rails.root + "test/fixtures/blue_car.jpg"
    attach_file('car_image', file_path)
    click_button 'Update Car'
    assert has_no_content? 'Car updated successfully.'
    assert has_content? 'Image is too long'
  end

  test "user adds file with improper format" do
    visit cars_path
    click_link "edit_#{@car.id}"
    file_path = Rails.root + "test/fixtures/test.txt"
    attach_file('car_image', file_path)
    click_button 'Update Car'
    assert has_no_content? 'Car updated successfully.'
    assert has_content? 'Image format is incorrect'
  end

  test "user removes car image" do
    visit cars_path
    click_link "edit_#{@car.id}"
    check('car_remove_image')
    click_button 'Update Car'
    assert has_no_content? 'Image:'
  end

end
