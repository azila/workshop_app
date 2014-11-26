class Account < ActiveRecord::Base
  belongs_to :person
  has_secure_password
  accepts_nested_attributes_for :person
  after_create :send_email 

  def self.authenticate(email, password)
    account = Account.find_by_email(email)
    account.authenticate(password) if account
  end

  def send_email
    ParkingsMailer.registration_email(self).deliver
  end

end

