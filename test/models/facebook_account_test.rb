require 'test_helper'

class FacebookAccountTest < ActiveSupport::TestCase

  test "should find and return existing facebook account" do
    OmniAuth.config.mock_auth[:facebook]  = OmniAuth::AuthHash.new(
    {
      :provider => 'facebook',
      :uid => '1234567',
        :info => {
        :first_name => 'Yukihiro',
        :last_name => 'Matsumoto'
      }
    })

    fb_account = FacebookAccount.find_or_create_for_facebook(OmniAuth.config.mock_auth[:facebook])
    assert_equal facebook_accounts(:fb_account_one).person.full_name, fb_account.person.full_name
  end

  test "should create new person and fb account before log in" do
    OmniAuth.config.mock_auth[:facebook]  = OmniAuth::AuthHash.new(
    {
      :provider => 'facebook',
      :uid => '99999999',
        :info => {
        :first_name => 'John',
        :last_name => 'Nash'
      }
    })

    new_fb_account = FacebookAccount.find_or_create_for_facebook(OmniAuth.config.mock_auth[:facebook])
    assert_equal "John Nash", new_fb_account.person.full_name
    assert_equal 3, FacebookAccount.all.size
  end

end
