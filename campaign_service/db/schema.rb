# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2024_04_02_162405) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_emails", force: :cascade do |t|
    t.string "subject"
    t.text "body"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "action_waits", force: :cascade do |t|
    t.integer "duration"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "campaigns", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "customer_group_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "first_node_id"
    t.index ["first_node_id"], name: "index_campaigns_on_first_node_id"
  end

  create_table "conditions", force: :cascade do |t|
    t.string "event_type"
    t.string "criteria_key"
    t.string "criteria_value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "campaign_id", null: false
    t.index ["campaign_id"], name: "index_conditions_on_campaign_id"
  end

  create_table "nodes", force: :cascade do |t|
    t.bigint "campaign_id", null: false
    t.bigint "next_node_id"
    t.string "action_type", null: false
    t.bigint "action_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["action_type", "action_id"], name: "index_nodes_on_action_type_and_action_id"
    t.index ["campaign_id"], name: "index_nodes_on_campaign_id"
    t.index ["next_node_id"], name: "index_nodes_on_next_node_id"
  end

  create_table "user_activities", force: :cascade do |t|
    t.string "event_type"
    t.jsonb "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_user_activities_on_user_id"
  end

  create_table "user_campaign_progresses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "campaign_id", null: false
    t.bigint "node_id", null: false
    t.datetime "last_updated_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "completed"
    t.index ["campaign_id"], name: "index_user_campaign_progresses_on_campaign_id"
    t.index ["node_id"], name: "index_user_campaign_progresses_on_node_id"
    t.index ["user_id"], name: "index_user_campaign_progresses_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "conditions", "campaigns"
  add_foreign_key "nodes", "campaigns"
  add_foreign_key "nodes", "nodes", column: "next_node_id"
  add_foreign_key "user_activities", "users"
  add_foreign_key "user_campaign_progresses", "campaigns"
  add_foreign_key "user_campaign_progresses", "nodes"
  add_foreign_key "user_campaign_progresses", "users"
end
