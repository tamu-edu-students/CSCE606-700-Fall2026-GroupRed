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

ActiveRecord::Schema[8.1].define(version: 2026_10_30_171844) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "blocks", force: :cascade do |t|
    t.bigint "blocker_id", null: false
    t.bigint "blocked_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blocked_id"], name: "index_blocks_on_blocked_id"
    t.index ["blocker_id", "blocked_id"], name: "index_blocks_on_blocker_id_and_blocked_id", unique: true
    t.index ["blocker_id"], name: "index_blocks_on_blocker_id"
  end

  create_table "companions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name", default: "Wingman", null: false
    t.string "personality", default: "playful and honest, like a close friend", null: false
    t.text "memory_summary"
    t.text "greeting"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_companions_on_user_id", unique: true
  end

  create_table "matches", force: :cascade do |t|
    t.bigint "profile_1_id", null: false
    t.bigint "profile_2_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_1_id", "profile_2_id"], name: "index_matches_on_profile_1_id_and_profile_2_id", unique: true
    t.index ["profile_1_id"], name: "index_matches_on_profile_1_id"
    t.index ["profile_2_id"], name: "index_matches_on_profile_2_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "display_name", null: false
    t.text "bio"
    t.string "gender"
    t.string "interested_in"
    t.integer "age_min"
    t.integer "age_max"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_profiles_on_user_id", unique: true
  end

  create_table "swipes", force: :cascade do |t|
    t.bigint "swiper_id", null: false
    t.bigint "prospect_id", null: false
    t.boolean "liked", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["prospect_id"], name: "index_swipes_on_prospect_id"
    t.index ["swiper_id", "prospect_id"], name: "index_swipes_on_swiper_id_and_prospect_id", unique: true
    t.index ["swiper_id"], name: "index_swipes_on_swiper_id"
    t.check_constraint "swiper_id <> prospect_id", name: "swipes_cannot_target_self"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.date "date_of_birth", null: false
    t.string "role", default: "user", null: false
    t.datetime "suspended_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "blocks", "users", column: "blocked_id"
  add_foreign_key "blocks", "users", column: "blocker_id"
  add_foreign_key "companions", "users"
  add_foreign_key "matches", "profiles", column: "profile_1_id"
  add_foreign_key "matches", "profiles", column: "profile_2_id"
  add_foreign_key "profiles", "users"
  add_foreign_key "swipes", "profiles", column: "prospect_id"
  add_foreign_key "swipes", "profiles", column: "swiper_id"
end
