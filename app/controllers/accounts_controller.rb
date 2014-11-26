class AccountsController < ApplicationController
  skip_before_action :authenticate_account!
  
  def new
    @account = Account.new
    @account.build_person
  end

  def create

    account = Account.new(account_params)

    if account.save
      session[:person_id] = account.person_id
      flash[:notice] = "Account created successfully."
      redirect_to_root_or_back
    else
      render 'new'
    end
  end

  private
    def account_params
      params.require(:account).permit(:email, :password, :password_confirmation, person_attributes: [:first_name, :last_name] )
    end

end

