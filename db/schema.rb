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

ActiveRecord::Schema[8.1].define(version: 2026_11_09_004823) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "blocks", force: :cascade do |t|
    t.bigint "blocker_id", null: false
    t.bigint "blocked_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blocked_id"], name: "index_blocks_on_blocked_id"
    t.index ["blocker_id", "blocked_id"], name: "index_blocks_on_blocker_id_and_blocked_id", unique: true
    t.index ["blocker_id"], name: "index_blocks_on_blocker_id"
  end

  create_table "companion_messages", force: :cascade do |t|
    t.bigint "companion_id", null: false
    t.bigint "profile_id", null: false
    t.string "role", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["companion_id", "profile_id", "created_at"], name: "idx_on_companion_id_profile_id_created_at_d05a9f2989"
    t.index ["companion_id"], name: "index_companion_messages_on_companion_id"
    t.index ["profile_id"], name: "index_companion_messages_on_profile_id"
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

  create_table "messages", force: :cascade do |t|
    t.bigint "match_id", null: false
    t.bigint "sender_id", null: false
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id", "created_at"], name: "index_messages_on_match_id_and_created_at"
    t.index ["match_id"], name: "index_messages_on_match_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
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
    t.string "photo_alt_text"
    t.index ["user_id"], name: "index_profiles_on_user_id", unique: true
  end

  create_table "reports", force: :cascade do |t|
    t.bigint "reporter_id", null: false
    t.string "reportable_type", null: false
    t.bigint "reportable_id", null: false
    t.text "reason", null: false
    t.string "status", default: "open", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["reportable_type", "reportable_id"], name: "index_reports_on_reportable"
    t.index ["reporter_id"], name: "index_reports_on_reporter_id"
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "blocks", "users", column: "blocked_id"
  add_foreign_key "blocks", "users", column: "blocker_id"
  add_foreign_key "companion_messages", "companions"
  add_foreign_key "companion_messages", "profiles"
  add_foreign_key "companions", "users"
  add_foreign_key "matches", "profiles", column: "profile_1_id"
  add_foreign_key "matches", "profiles", column: "profile_2_id"
  add_foreign_key "messages", "matches"
  add_foreign_key "messages", "profiles", column: "sender_id"
  add_foreign_key "profiles", "users"
  add_foreign_key "reports", "users", column: "reporter_id"
  add_foreign_key "swipes", "profiles", column: "prospect_id"
  add_foreign_key "swipes", "profiles", column: "swiper_id"
end
