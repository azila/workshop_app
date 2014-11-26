require 'test_helper'
require 'capybara/rails'

class FacebookTest < ActionDispatch::IntegrationTest

  test "should successfully log in with facebook account" do
    set_valid_mock
    visit '/auth/facebook'
    assert has_content? 'Liza Korotchenko'
  end

  test "should not log in with invalid credentials" do
    set_invalid_mock
    silence_omniauth {visit '/auth/facebook'}
    assert has_content? 'Facebook authentication failed.'
  end

end
