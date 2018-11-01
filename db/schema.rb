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

ActiveRecord::Schema.define(version: 20181031105715) do

  create_table "albums", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.date     "date_released"
    t.integer  "year"
    t.string   "copyright"
    t.string   "cover_pic_name"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "artist_id"
  end

  create_table "covers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "link"
    t.integer  "album_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["album_id"], name: "index_covers_on_album_id", using: :btree
  end

  create_table "events", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "key"
    t.string   "val"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "people", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "uid"
    t.string   "manager_id"
    t.string   "provider"
    t.string   "email"
    t.string   "pw"
    t.string   "oauth_token"
    t.string   "salt"
    t.boolean  "force_new_pw",                          default: false
    t.string   "locale",                                default: "fr"
    t.string   "authentication_token"
    t.string   "profile_pic_name"
    t.boolean  "profile_complete_signup",               default: false
    t.text     "roles",                   limit: 65535
    t.text     "tags",                    limit: 65535
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.integer  "event_id"
    t.string   "type"
    t.string   "language",                              default: "fr"
    t.index ["event_id"], name: "index_people_on_event_id", using: :btree
  end

  create_table "person_configs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.boolean  "has_tracker_profile"
    t.string   "pw_reinit_key"
    t.datetime "pw_reinit_exp"
    t.integer  "failed_auth_count"
    t.time     "lock_until"
    t.string   "lock_cause"
    t.integer  "lock_count"
    t.integer  "person_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["person_id"], name: "index_person_configs_on_person_id", using: :btree
  end

  create_table "playlists", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_playlists_on_person_id", using: :btree
  end

  create_table "search_indices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "r"
    t.string   "l"
    t.string   "s"
    t.text     "a",          limit: 65535
    t.integer  "album_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "person_id"
    t.integer  "manager_id"
    t.integer  "artist_id"
    t.index ["album_id"], name: "index_search_indices_on_album_id", using: :btree
  end

  create_table "songs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "order"
    t.string   "title"
    t.string   "ext"
    t.string   "ext_orig"
    t.integer  "published"
    t.date     "published_date"
    t.integer  "duration"
    t.integer  "album_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "artist_id"
    t.index ["album_id"], name: "index_songs_on_album_id", using: :btree
  end

  add_foreign_key "covers", "albums"
  add_foreign_key "people", "events"
  add_foreign_key "person_configs", "people"
  add_foreign_key "playlists", "people"
  add_foreign_key "search_indices", "albums"
  add_foreign_key "songs", "albums"
end
