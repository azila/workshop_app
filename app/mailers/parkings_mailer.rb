class ParkingsMailer < ActionMailer::Base

  default :from => "hello@bookparking.dev"

  def registration_email(account)
    @account = account
    mail(:to => @account.email, :subject => "Welcome to Bookparking")
  end

end
