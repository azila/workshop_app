class RemoveNameFromFacebookAccount < ActiveRecord::Migration
  def change
    remove_column :facebook_accounts, :first_name, :string
    remove_column :facebook_accounts, :last_name, :string
  end
end
