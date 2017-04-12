# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170412131926) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "founder_links", force: :cascade do |t|
    t.bigint "founder_id"
    t.string "kind"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["founder_id"], name: "index_founder_links_on_founder_id"
  end

  create_table "founders", force: :cascade do |t|
    t.bigint "startup_id"
    t.string "picture"
    t.string "name"
    t.string "title"
    t.string "profile"
    t.text "bio"
    t.date "parsed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["startup_id"], name: "index_founders_on_startup_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.string "url"
    t.text "text"
    t.text "compensation"
    t.bigint "startup_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["startup_id"], name: "index_jobs_on_startup_id"
  end

  create_table "jobs_tags", id: false, force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.bigint "job_id", null: false
  end

  create_table "links", force: :cascade do |t|
    t.string "url"
    t.bigint "startup_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["startup_id"], name: "index_links_on_startup_id"
  end

  create_table "startups", force: :cascade do |t|
    t.text "title"
    t.string "url"
    t.text "description"
    t.string "status"
    t.string "applicants"
    t.string "location"
    t.string "employees"
    t.text "product"
    t.text "why_us"
    t.datetime "parsed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "founder_links", "founders"
  add_foreign_key "founders", "startups"
  add_foreign_key "jobs", "startups"
  add_foreign_key "links", "startups"
end
