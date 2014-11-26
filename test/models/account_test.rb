require 'test_helper'

class AccountTest < ActiveSupport::TestCase
  def setup
    @account = accounts(:account_one)
  end

  test "should return account if email and password are correct" do
    account = Account.authenticate('korotchenko.liza@gmail.com', 'ruby')
    assert_equal @account, account
  end

  test "should return false if email is wrong" do
    assert_not Account.authenticate('wrong@gmail.com', 'ruby')
  end

  test "should return false if password is wrong" do
    assert_not Account.authenticate('korotchenko.liza@gmail.com', 'wrong')
  end

end
