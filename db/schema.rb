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

ActiveRecord::Schema.define(version: 20161113081838) do

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.boolean  "donation_enforced"
    t.integer  "max_items_per_seller"
    t.datetime "deleted_at"
  end

  add_index "categories", ["deleted_at"], name: "index_categories_on_deleted_at"
  add_index "categories", ["name"], name: "index_categories_on_name", where: "deleted_at IS NULL"

  create_table "emails", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "seller_id"
    t.string   "to"
    t.string   "subject"
    t.text     "body"
    t.boolean  "sent"
  end

  add_index "emails", ["seller_id"], name: "index_emails_on_seller_id"

  create_table "events", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.text     "details"
    t.integer  "max_sellers"
    t.integer  "max_items_per_seller"
    t.boolean  "confirmed"
    t.datetime "reservation_start"
    t.datetime "reservation_end"
    t.integer  "kind"
    t.decimal  "price_precision",                  precision: 3, scale: 2
    t.decimal  "commission_rate",                  precision: 3, scale: 2
    t.decimal  "seller_fee",                       precision: 4, scale: 2
    t.boolean  "donation_of_unsold_items_enabled"
    t.string   "token"
    t.integer  "max_reservations_per_seller"
  end

  add_index "events", ["token"], name: "index_events_on_token", unique: true

  create_table "items", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.string   "description"
    t.string   "size"
    t.decimal  "price",          precision: 5, scale: 1
    t.integer  "reservation_id"
    t.integer  "number"
    t.string   "code"
    t.datetime "sold"
    t.boolean  "donation"
  end

  add_index "items", ["category_id"], name: "index_items_on_category_id"
  add_index "items", ["code"], name: "index_items_on_code", unique: true
  add_index "items", ["reservation_id", "number"], name: "index_items_on_reservation_id_and_number", unique: true
  add_index "items", ["reservation_id"], name: "index_items_on_reservation_id"

  create_table "messages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "category"
    t.integer  "event_id"
  end

  add_index "messages", ["category", "event_id"], name: "index_messages_on_category_and_event_id", unique: true
  add_index "messages", ["event_id"], name: "index_messages_on_event_id"

  create_table "notifications", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "event_id"
    t.integer  "seller_id"
  end

  add_index "notifications", ["event_id", "seller_id"], name: "index_notifications_on_event_id_and_seller_id", unique: true
  add_index "notifications", ["event_id"], name: "index_notifications_on_event_id"
  add_index "notifications", ["seller_id"], name: "index_notifications_on_seller_id"

  create_table "reservations", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "seller_id"
    t.integer  "event_id"
    t.integer  "number"
    t.integer  "label_counter"
    t.decimal  "commission_rate", precision: 3, scale: 2
    t.decimal  "fee",             precision: 3, scale: 2
  end

  add_index "reservations", ["event_id", "number"], name: "index_reservations_on_event_id_and_number", unique: true
  add_index "reservations", ["event_id"], name: "index_reservations_on_event_id"
  add_index "reservations", ["seller_id"], name: "index_reservations_on_seller_id"

  create_table "reviews", force: :cascade do |t|
    t.integer  "event_id"
    t.integer  "seller_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "registration"
    t.integer  "items"
    t.integer  "print"
    t.integer  "reservation"
    t.integer  "mailing"
    t.integer  "content"
    t.integer  "design"
    t.integer  "support"
    t.integer  "handover"
    t.integer  "payoff"
    t.integer  "sale"
    t.integer  "organization"
    t.integer  "total"
    t.string   "source"
    t.boolean  "recommend"
    t.text     "to_improve"
  end

  add_index "reviews", ["event_id"], name: "index_reviews_on_event_id"
  add_index "reviews", ["seller_id"], name: "index_reviews_on_seller_id"

  create_table "sellers", force: :cascade do |t|
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
    t.boolean  "mailing"
    t.boolean  "active"
    t.datetime "deleted_at"
  end

  add_index "sellers", ["deleted_at"], name: "index_sellers_on_deleted_at"
  add_index "sellers", ["email"], name: "index_sellers_on_email", unique: true, where: "deleted_at IS NULL"
  add_index "sellers", ["token"], name: "index_sellers_on_token", unique: true, where: "deleted_at IS NULL"

  create_table "time_periods", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "kind"
    t.integer  "event_id"
    t.datetime "min"
    t.datetime "max"
  end

  add_index "time_periods", ["event_id"], name: "index_time_periods_on_event_id"
  add_index "time_periods", ["kind"], name: "index_time_periods_on_kind"

  create_table "users", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",            null: false
    t.string   "crypted_password"
    t.string   "salt"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
