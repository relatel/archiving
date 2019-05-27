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

ActiveRecord::Schema.define(version: 2019_07_11_112558) do

  create_table "log_days", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci", force: :cascade do |t|
    t.integer "post_id"
    t.date "day"
    t.string "postable_type"
    t.integer "postable_id"
  end

  create_table "log_days_archive", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci", force: :cascade do |t|
    t.integer "post_id"
    t.date "day"
    t.string "postable_type"
    t.integer "postable_id"
  end

  create_table "log_lines", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci", force: :cascade do |t|
    t.integer "log_day_id"
    t.string "descr"
  end

  create_table "log_lines_archive", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci", force: :cascade do |t|
    t.integer "log_day_id"
    t.string "descr"
  end

  create_table "log_others", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci", force: :cascade do |t|
    t.integer "post_id"
    t.string "note"
  end

  create_table "log_others_archive", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci", force: :cascade do |t|
    t.integer "post_id"
    t.string "note"
  end

  create_table "postrws", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "postrws_archive", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "tag"
  end

  create_table "posts_archive", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_danish_ci", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "tag"
  end

end
