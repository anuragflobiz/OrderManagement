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

ActiveRecord::Schema.define(version: 2026_02_24_115933) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "item_orders", force: :cascade do |t|
    t.bigint "item_id"
    t.bigint "order_id"
    t.integer "quantity"
    t.decimal "item_price", precision: 10, scale: 2
    t.string "item_name"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_item_orders_on_item_id"
    t.index ["order_id"], name: "index_item_orders_on_order_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.decimal "price", precision: 10, scale: 2
    t.integer "quantity"
    t.bigint "user_id"
    t.integer "lock_version"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_items_on_user_id"
  end

  create_table "message_templates", force: :cascade do |t|
    t.string "name"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "message_template_id"
    t.jsonb "metadata"
    t.integer "status"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["message_template_id"], name: "index_messages_on_message_template_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2
    t.bigint "user_id"
    t.integer "status"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "phone_number"
    t.string "password_digest"
    t.integer "role"
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "item_orders", "items"
  add_foreign_key "item_orders", "orders"
  add_foreign_key "items", "users"
  add_foreign_key "messages", "message_templates"
  add_foreign_key "messages", "users"
  add_foreign_key "orders", "users"
end
