class CreatePlaceRents < ActiveRecord::Migration
  def change
    create_table :place_rents do |t|
      t.integer :parking_id
      t.integer :car_id
      t.datetime :start_date
      t.datetime :end_date
      t.decimal :price

      t.timestamps
    end
  end
end
