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

ActiveRecord::Schema.define(version: 2018_00_00_000001) do

  create_table "problems", force: :cascade do |t|
    t.string "code", null: false
    t.string "title", null: false
    t.string "time_limit", null: false
    t.string "mmemory_limit", null: false
    t.integer "solved_user", null: false
    t.integer "submissions", null: false
    t.string "volume"
    t.string "large_cl"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_problems_on_code", unique: true
  end

  create_table "user_problems", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "problem_id", null: false
    t.boolean "solved", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["problem_id"], name: "index_user_problems_on_problem_id"
    t.index ["user_id"], name: "index_user_problems_on_user_id"
    t.index [nil, nil], name: "index_user_problems_on_user_and_problem", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "name", null: false
    t.boolean "administrator", default: false, null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["name"], name: "index_users_on_name", unique: true
  end

end
