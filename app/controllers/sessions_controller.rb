class SessionsController < ApplicationController
  skip_before_action :authenticate_account!
  
  def new
    @account = Account.new
  end

  def create
    if params[:provider]
      account = FacebookAccount.find_or_create_for_facebook(env["omniauth.auth"])
    else
      account = Account.authenticate(params[:email], params[:password])
      redirect_to login_path, notice: "Wrong password or login." unless account
    end

    session[:person_id] = account.person_id
    redirect_to_root_or_back
  end

  def destroy
    logout!
    redirect_to login_path, notice: "You are now logged out."
  end

  def failure
    redirect_to root_path, alert: "Facebook authentication failed."
  end

end
