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

ActiveRecord::Schema.define(version: 20141125201632) do

  create_table "categories", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "categories", ["name"], name: "index_categories_on_name", unique: true

  create_table "events", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "details"
    t.integer  "max_sellers"
    t.integer  "max_items_per_seller"
    t.boolean  "confirmed"
    t.datetime "shopping_start"
    t.datetime "shopping_end"
    t.datetime "reservation_start"
    t.datetime "reservation_end"
    t.datetime "handover_start"
    t.datetime "handover_end"
    t.datetime "pickup_start"
    t.datetime "pickup_end"
    t.integer  "kind"
  end

  create_table "items", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "seller_id"
    t.integer  "category_id"
    t.string   "description"
    t.string   "size"
    t.decimal  "price"
  end

  add_index "items", ["category_id"], name: "index_items_on_category_id"
  add_index "items", ["seller_id"], name: "index_items_on_seller_id"

  create_table "notifications", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id"
    t.integer  "seller_id"
  end

  add_index "notifications", ["event_id", "seller_id"], name: "index_notifications_on_event_id_and_seller_id", unique: true
  add_index "notifications", ["event_id"], name: "index_notifications_on_event_id"
  add_index "notifications", ["seller_id"], name: "index_notifications_on_seller_id"

  create_table "reservations", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "seller_id"
    t.integer  "event_id"
    t.integer  "number"
  end

  add_index "reservations", ["event_id", "number"], name: "index_reservations_on_event_id_and_number", unique: true
  add_index "reservations", ["event_id", "seller_id"], name: "index_reservations_on_event_id_and_seller_id", unique: true
  add_index "reservations", ["event_id"], name: "index_reservations_on_event_id"
  add_index "reservations", ["seller_id"], name: "index_reservations_on_seller_id"

  create_table "reserved_items", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "reservation_id"
    t.integer  "item_id"
    t.integer  "number"
    t.string   "code"
    t.datetime "sold"
  end

  add_index "reserved_items", ["code"], name: "index_reserved_items_on_code", unique: true
  add_index "reserved_items", ["item_id"], name: "index_reserved_items_on_item_id"
  add_index "reserved_items", ["reservation_id", "item_id"], name: "index_reserved_items_on_reservation_id_and_item_id", unique: true
  add_index "reserved_items", ["reservation_id", "number"], name: "index_reserved_items_on_reservation_id_and_number", unique: true
  add_index "reserved_items", ["reservation_id"], name: "index_reserved_items_on_reservation_id"

  create_table "reviews", force: true do |t|
    t.integer  "event_id"
    t.integer  "seller_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "reviews", ["event_id"], name: "index_reviews_on_event_id"
  add_index "reviews", ["seller_id"], name: "index_reviews_on_seller_id"

  create_table "sellers", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "street"
    t.string   "zip_code"
    t.string   "city"
    t.string   "email"
    t.string   "phone"
    t.string   "token"
  end

  add_index "sellers", ["email"], name: "index_sellers_on_email", unique: true
  add_index "sellers", ["token"], name: "index_sellers_on_token", unique: true

end
