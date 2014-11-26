class CreateFacebookAccounts < ActiveRecord::Migration
  def change
    create_table :facebook_accounts do |t|
      t.string :provider
      t.string :uid
      t.string :first_name
      t.string :last_name
      t.integer :person_id

      t.timestamps
    end
  end
end
