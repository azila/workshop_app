class Person < ActiveRecord::Base
  has_many :parkings, foreign_key: "owner_id"
  has_many :cars, foreign_key: "owner_id"
  has_one :account
  validates :first_name, presence: true
  has_one :facebook_account

  def full_name
    "#{first_name} #{last_name}".strip
  end
end
