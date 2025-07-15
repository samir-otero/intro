class CreateCharacters < ActiveRecord::Migration[7.0]
  def change
    create_table :characters do |t|
      t.integer :api_id
      t.string :name
      t.string :status
      t.string :species
      t.string :gender
      t.string :image_url
      t.references :origin_location, null: true, foreign_key: { to_table: :locations }
      t.references :current_location, null: true, foreign_key: { to_table: :locations }
      t.timestamps
    end
  end
end
