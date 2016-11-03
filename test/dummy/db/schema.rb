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

ActiveRecord::Schema.define(version: 20161103110724) do

  create_table "log_days", force: :cascade do |t|
    t.integer "post_id",       limit: 4
    t.date    "day"
    t.string  "postable_type", limit: 255
    t.integer "postable_id",   limit: 4
  end

  create_table "log_days_archive", force: :cascade do |t|
    t.integer "post_id",       limit: 4
    t.date    "day"
    t.string  "postable_type", limit: 255
    t.integer "postable_id",   limit: 4
  end

  create_table "log_lines", force: :cascade do |t|
    t.integer "log_day_id", limit: 4
    t.string  "descr",      limit: 255
  end

  create_table "log_lines_archive", force: :cascade do |t|
    t.integer "log_day_id", limit: 4
    t.string  "descr",      limit: 255
  end

  create_table "log_others", force: :cascade do |t|
    t.integer "post_id", limit: 4
    t.string  "note",    limit: 255
  end

  create_table "log_others_archive", force: :cascade do |t|
    t.integer "post_id", limit: 4
    t.string  "note",    limit: 255
  end

  create_table "posts", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "body",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tag",        limit: 255
  end

  create_table "posts_archive", force: :cascade do |t|
    t.string   "title",      limit: 255
    t.text     "body",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tag",        limit: 255
  end

end
