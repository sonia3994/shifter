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

ActiveRecord::Schema.define(version: 20160326200647) do

  create_table "appointments", force: :cascade do |t|
    t.datetime "created"
    t.date     "starts"
    t.text     "note"
    t.integer  "calendar_id"
    t.integer  "person_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.date     "ends"
  end

  add_index "appointments", ["calendar_id"], name: "index_appointments_on_calendar_id"
  add_index "appointments", ["person_id"], name: "index_appointments_on_person_id"

  create_table "articles", force: :cascade do |t|
    t.string   "title"
    t.text     "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "calendars", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "max_simultaneous"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", force: :cascade do |t|
    t.string   "name"
    t.integer  "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "email"
    t.string   "phone"
  end

  add_index "people", ["group_id"], name: "index_people_on_group_id"

end
