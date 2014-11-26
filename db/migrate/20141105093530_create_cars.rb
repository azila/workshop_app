class CreateCars < ActiveRecord::Migration
  def change
    create_table :cars do |t|
      t.string :registration_number
      t.string :model
      t.string :owner_id

      t.timestamps
    end
  end
end
