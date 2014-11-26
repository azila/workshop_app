require 'test_helper'
require 'capybara/rails'

class PeopleTest < ActionDispatch::IntegrationTest

  test "person name is displayed on log in" do
    Capybara.reset!
    visit login_path
    fill_in 'email', with: 'korotchenko.liza@gmail.com'
    fill_in 'password', with: 'ruby'
    click_on 'Log in'
    assert has_content? 'Liza Korotchenko'
  end

  test "person name is not displayed before log in" do
    Capybara.reset!
    visit login_path
    assert has_no_content? 'Liza Korotchenko'
  end

  test "person cannot access pages before log in" do
    Capybara.reset!
    visit login_path
    click_on 'Cars'
    assert has_content? 'Log in to have access to site resources.'
  end

  test "person can access pages after log in" do
    Capybara.reset!
    visit login_path
    fill_in 'email', with: 'korotchenko.liza@gmail.com'
    fill_in 'password', with: 'ruby'
    click_on 'Log in'
    click_on 'Cars'
    assert has_no_content? 'Log in to have access to site resources.'
  end

  test "person logs out" do
    Capybara.reset!
    visit login_path
    fill_in 'email', with: 'korotchenko.liza@gmail.com'
    fill_in 'password', with: 'ruby'
    click_on 'Log in'

    click_on 'Log out'
    assert has_no_content? 'Liza Korotchenko'
    assert has_content? 'You are now logged out.'
  end

  test "person is redirected to previous location" do
    Capybara.reset!
    visit cars_path
    fill_in 'email', with: 'korotchenko.liza@gmail.com'
    fill_in 'password', with: 'ruby'
    click_on 'Log in'

    assert has_content? 'Liza Korotchenko'
    page.has_xpath?('cars')
  end

  test "person creates a new account" do
    Capybara.reset!
    visit root_path
    click_on 'Sign up'

    fill_in 'account_email', with: 'new.person@nowhere.com'
    fill_in 'account_password', with: 'rails'
    fill_in 'account_password_confirmation', with: 'rails'
    fill_in 'account_person_attributes_first_name', with: 'Steve'
    fill_in 'account_person_attributes_last_name', with: 'Jobs'
    click_on 'sign_up_button'
    assert has_content? 'Account created successfully.'
    assert has_content? 'Steve Jobs'

    email = ActionMailer::Base.deliveries.last
    assert_equal ["hello@bookparking.dev"], email.from
    assert_equal ['new.person@nowhere.com'], email.to
    assert_equal 'Welcome to Bookparking', email.subject
  end

end


    
