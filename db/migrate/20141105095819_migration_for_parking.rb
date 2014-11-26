class MigrationForParking < ActiveRecord::Migration
  def change
  	create_table :parkings do |t|
      t.string  :kind
      t.decimal :hour_price
      t.decimal :day_price
      t.integer :places
      t.integer :owner_id
      t.integer :address_id

      t.timestamps
    end
  end
end
