class CreateEpisodes < ActiveRecord::Migration[8.0]
  def change
    create_table :episodes do |t|
      t.integer :api_id
      t.string :name
      t.string :air_date
      t.string :episode_code

      t.timestamps
    end
  end
end
