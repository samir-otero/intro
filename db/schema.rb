# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_07_15_145207) do
  create_table "character_episodes", force: :cascade do |t|
    t.integer "character_id", null: false
    t.integer "episode_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_character_episodes_on_character_id"
    t.index ["episode_id"], name: "index_character_episodes_on_episode_id"
  end

  create_table "characters", force: :cascade do |t|
    t.integer "api_id"
    t.string "name"
    t.string "status"
    t.string "species"
    t.string "gender"
    t.string "image_url"
    t.integer "origin_location_id"
    t.integer "current_location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["current_location_id"], name: "index_characters_on_current_location_id"
    t.index ["origin_location_id"], name: "index_characters_on_origin_location_id"
  end

  create_table "episodes", force: :cascade do |t|
    t.integer "api_id"
    t.string "name"
    t.string "air_date"
    t.string "episode_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "locations", force: :cascade do |t|
    t.integer "api_id"
    t.string "name"
    t.string "location_type"
    t.string "dimension"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "character_episodes", "characters"
  add_foreign_key "character_episodes", "episodes"
  add_foreign_key "characters", "locations", column: "current_location_id"
  add_foreign_key "characters", "locations", column: "origin_location_id"
end
