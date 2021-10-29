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

ActiveRecord::Schema.define(version: 20211011042200) do

  create_table "activities", force: :cascade do |t|
    t.string "entity_type", null: false
    t.integer "entity_id", null: false
    t.string "action", null: false
    t.integer "actor_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actor_id"], name: "index_activities_on_actor_id"
    t.index ["entity_type", "entity_id"], name: "index_activities_on_entity_type_and_entity_id"
  end

  create_table "actors", force: :cascade do |t|
    t.string "name"
    t.string "federated_url"
    t.string "server"
    t.string "inbox_url"
    t.string "outbox_url"
    t.string "followers_url"
    t.string "followings_url"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.index ["federated_url"], name: "index_actors_on_federated_url", unique: true
    t.index ["user_id"], name: "index_actors_on_user_id", unique: true
  end

  create_table "notes", force: :cascade do |t|
    t.text "content", null: false
    t.integer "actor_id", null: false
    t.string "federated_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actor_id"], name: "index_notes_on_actor_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password"
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
