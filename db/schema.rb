# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20141212010613) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: true do |t|
    t.json     "raw"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "categories",   default: [], array: true
    t.string   "email"
    t.string   "name"
    t.datetime "occurred_at"
    t.datetime "processed_at"
    t.string   "public_uid"
  end

  add_index "events", ["public_uid"], name: "index_events_on_public_uid", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "token"
    t.string   "application_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "creator",          default: false
  end

end
