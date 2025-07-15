class CreateCharacters < ActiveRecord::Migration[8.0]
  def change
    create_table :characters do |t|
      t.integer :api_id
      t.string :name
      t.string :status
      t.string :species
      t.string :gender
      t.string :image_url
      t.references :origin_location, null: false, foreign_key: true
      t.references :current_location, null: false, foreign_key: true

      t.timestamps
    end
  end
end
