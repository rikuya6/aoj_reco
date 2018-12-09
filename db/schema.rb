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

  create_table "admins", force: :cascade do |t|
    t.string "name", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "problems", force: :cascade do |t|
    t.string "code", null: false
    t.string "title", null: false
    t.string "time_limit", null: false
    t.string "mmemory_limit", null: false
    t.integer "solved_user", null: false
    t.integer "submissions", null: false
    t.string "success_rate", null: false
    t.string "volume"
    t.float "difficulty"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_problems_on_code", unique: true
  end

  create_table "user_problems", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "problem_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["problem_id"], name: "index_user_problems_on_problem_id"
    t.index ["user_id", "problem_id"], name: "index_user_problems_on_user_id_and_problem_id", unique: true
    t.index ["user_id"], name: "index_user_problems_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "code", null: false
    t.string "name", null: false
    t.integer "submissions", default: 0, null: false
    t.integer "solved", default: 0, null: false
    t.integer "accepted", default: 0, null: false
    t.integer "wronganswer", default: 0, null: false
    t.integer "timelimit", default: 0, null: false
    t.integer "memorylimit", default: 0, null: false
    t.integer "outputlimit", default: 0, null: false
    t.integer "compileerror", default: 0, null: false
    t.integer "runtimeerror", default: 0, null: false
    t.float "ability"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_users_on_code", unique: true
  end

end
