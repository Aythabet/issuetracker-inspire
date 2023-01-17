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

ActiveRecord::Schema[7.0].define(version: 2023_01_17_065446) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dailyreport_issues", force: :cascade do |t|
    t.bigint "dailyreport_id", null: false
    t.bigint "issue_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dailyreport_id"], name: "index_dailyreport_issues_on_dailyreport_id"
    t.index ["issue_id"], name: "index_dailyreport_issues_on_issue_id"
  end

  create_table "dailyreports", force: :cascade do |t|
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "owner_id"
    t.index ["owner_id"], name: "index_dailyreports_on_owner_id"
  end

  create_table "departements", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "issues", force: :cascade do |t|
    t.string "jiraid"
    t.float "time_forecast"
    t.float "time_real"
    t.string "departement"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "retour_test"
    t.bigint "project_id"
    t.bigint "owner_id"
    t.bigint "dailyreports_id"
    t.string "status"
    t.index ["dailyreports_id"], name: "index_issues_on_dailyreports_id"
    t.index ["owner_id"], name: "index_issues_on_owner_id"
    t.index ["project_id"], name: "index_issues_on_project_id"
  end

  create_table "owners", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jiraid"
    t.string "status"
    t.string "date_joined_jira"
    t.string "last_seen_on_jira"
    t.string "departement"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_owners_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "jiraid"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "link"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "dailyreport_issues", "dailyreports"
  add_foreign_key "dailyreport_issues", "issues"
  add_foreign_key "issues", "owners"
  add_foreign_key "issues", "projects"
  add_foreign_key "owners", "users"
end
