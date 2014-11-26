ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  include Capybara::DSL

  def log_in_user
    visit login_path
    fill_in 'email', :with => 'korotchenko.liza@gmail.com'
    fill_in 'password', :with => 'ruby'
    click_on 'Log in'
  end

  def log_out_user
    click_link 'Log out'
  end

  OmniAuth.config.test_mode = true

  def set_valid_mock
    OmniAuth.config.mock_auth[:facebook]  = OmniAuth::AuthHash.new(
    {
      :provider => 'facebook',
      :uid => '7654321',
        :info => {
        :first_name => 'Liza',
        :last_name => 'Korotchenko'
      }
    })
  end

  def set_invalid_mock 
    OmniAuth.config.mock_auth[:facebook]  = :invalid_credentials
  end

  def silence_omniauth
    previous_logger = OmniAuth.config.logger
    OmniAuth.config.logger = Logger.new("/dev/null")
    yield
  ensure
    OmniAuth.config.logger = previous_logger
  end

end
