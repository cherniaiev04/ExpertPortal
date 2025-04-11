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

ActiveRecord::Schema[7.2].define(version: 2025_01_08_120909) do
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

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "categories_experts", id: false, force: :cascade do |t|
    t.integer "expert_id", null: false
    t.integer "category_id", null: false
    t.index ["category_id", "expert_id"], name: "index_categories_experts_on_category_id_and_expert_id"
    t.index ["expert_id", "category_id"], name: "index_categories_experts_on_expert_id_and_category_id"
  end

  create_table "course_modules", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
  end

  create_table "course_modules_experts", id: false, force: :cascade do |t|
    t.integer "expert_id", null: false
    t.integer "course_module_id", null: false
    t.index ["course_module_id", "expert_id"], name: "index_course_modules_experts_on_course_module_id_and_expert_id"
    t.index ["expert_id", "course_module_id"], name: "index_course_modules_experts_on_expert_id_and_course_module_id"
  end

  create_table "experts", force: :cascade do |t|
    t.string "name"
    t.string "firstname"
    t.string "email"
    t.string "expertise"
    t.string "institution"
    t.string "additionalInfo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
    t.string "salutation"
    t.string "telephone"
    t.string "nationality"
    t.float "hourlyRate"
    t.float "dailyRate"
    t.json "travel_willingness"
    t.json "lesson_language"
    t.json "communication_language"
    t.string "location"
    t.boolean "institution_bool", default: false, null: false
    t.string "cooperation"
    t.text "expInChina"
    t.text "travel_info"
    t.string "short_term_availability"
  end

  create_table "experts_projects", id: false, force: :cascade do |t|
    t.integer "expert_id", null: false
    t.integer "project_id", null: false
    t.index ["expert_id", "project_id"], name: "index_experts_projects_on_expert_id_and_project_id"
    t.index ["project_id", "expert_id"], name: "index_experts_projects_on_project_id_and_expert_id"
  end

  create_table "invitations", force: :cascade do |t|
    t.string "token"
    t.string "email"
    t.datetime "expires_at"
    t.boolean "used"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.string "name"
    t.date "time_period_start"
    t.date "time_period_end"
    t.text "schedule"
    t.string "participants"
    t.text "location"
    t.string "clients"
    t.string "expertise"
    t.text "project_type"
    t.text "key_topics"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "role", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "expert_id"
    t.boolean "initiated", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["expert_id"], name: "index_users_on_expert_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "categories_experts", "categories"
  add_foreign_key "categories_experts", "experts"
  add_foreign_key "experts_projects", "experts"
  add_foreign_key "experts_projects", "projects"
  add_foreign_key "users", "experts"
end
