class CreateLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :locations do |t|
      t.integer :api_id
      t.string :name
      t.string :type
      t.string :dimension

      t.timestamps
    end
  end
end
