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

ActiveRecord::Schema.define(version: 20180226175532) do

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "name"
    t.boolean  "donation_enforced"
    t.integer  "max_items_per_seller"
    t.datetime "deleted_at"
    t.integer  "parent_id"
    t.integer  "client_id"
  end

  add_index "categories", ["client_id"], name: "index_categories_on_client_id"
  add_index "categories", ["deleted_at"], name: "index_categories_on_deleted_at"
  add_index "categories", ["name"], name: "index_categories_on_name", where: "deleted_at IS NULL"

  create_table "clients", force: :cascade do |t|
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
    t.string   "key"
    t.string   "prefix"
    t.string   "domain"
    t.string   "name"
    t.string   "short_name"
    t.string   "logo"
    t.string   "address"
    t.string   "invoice_address"
    t.string   "intro"
    t.string   "outro"
    t.string   "mail_address"
    t.string   "terms"
    t.decimal  "reservation_fee",                  precision: 4, scale: 2
    t.decimal  "commission_rate",                  precision: 3, scale: 2
    t.decimal  "price_precision",                  precision: 3, scale: 2
    t.boolean  "donation_of_unsold_items"
    t.boolean  "donation_of_unsold_items_default"
    t.boolean  "reservation_by_seller_forbidden"
    t.boolean  "reservation_numbers_assignable"
  end

  add_index "clients", ["domain"], name: "index_clients_on_domain", unique: true
  add_index "clients", ["key"], name: "index_clients_on_key", unique: true
  add_index "clients", ["prefix"], name: "index_clients_on_prefix", unique: true

  create_table "emails", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "seller_id"
    t.string   "to"
    t.string   "subject"
    t.text     "body"
    t.boolean  "sent"
    t.string   "from"
    t.string   "cc"
    t.string   "message_id"
    t.boolean  "read"
    t.string   "kind"
    t.integer  "parent_id"
  end

  add_index "emails", ["message_id"], name: "index_emails_on_message_id", unique: true
  add_index "emails", ["parent_id"], name: "index_emails_on_parent_id"
  add_index "emails", ["read"], name: "index_emails_on_read"
  add_index "emails", ["seller_id"], name: "index_emails_on_seller_id"

  create_table "events", force: :cascade do |t|
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.string   "name"
    t.text     "details"
    t.integer  "max_reservations"
    t.integer  "max_items_per_reservation"
    t.boolean  "confirmed"
    t.datetime "reservation_start"
    t.datetime "reservation_end"
    t.integer  "kind"
    t.decimal  "price_precision",                   precision: 3, scale: 2
    t.decimal  "commission_rate",                   precision: 3, scale: 2
    t.decimal  "reservation_fee",                   precision: 4, scale: 2
    t.boolean  "donation_of_unsold_items_enabled"
    t.string   "token"
    t.integer  "max_reservations_per_seller"
    t.boolean  "reservation_fees_payed_in_advance"
    t.integer  "client_id"
    t.integer  "number"
  end

  add_index "events", ["client_id"], name: "index_events_on_client_id"
  add_index "events", ["number", "client_id"], name: "index_events_on_number_and_client_id", unique: true
  add_index "events", ["token"], name: "index_events_on_token", unique: true

  create_table "hardware", force: :cascade do |t|
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "description"
    t.decimal  "price",       precision: 5, scale: 1
  end

  add_index "hardware", ["description"], name: "index_hardware_on_description", unique: true

  create_table "items", force: :cascade do |t|
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
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

  create_table "message_templates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "category"
    t.string   "subject"
    t.text     "body"
    t.integer  "client_id"
  end

  add_index "message_templates", ["category", "client_id"], name: "index_message_templates_on_category_and_client_id", unique: true
  add_index "message_templates", ["client_id"], name: "index_message_templates_on_client_id"

  create_table "messages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "category"
    t.integer  "event_id"
  end

  add_index "messages", ["category", "event_id"], name: "index_messages_on_category_and_event_id", unique: true
  add_index "messages", ["event_id"], name: "index_messages_on_event_id"

  create_table "notifications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "event_id"
    t.integer  "seller_id"
  end

  add_index "notifications", ["event_id", "seller_id"], name: "index_notifications_on_event_id_and_seller_id", unique: true
  add_index "notifications", ["event_id"], name: "index_notifications_on_event_id"
  add_index "notifications", ["seller_id"], name: "index_notifications_on_seller_id"

  create_table "rentals", force: :cascade do |t|
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "hardware_id"
    t.integer  "event_id"
    t.integer  "amount"
  end

  add_index "rentals", ["event_id"], name: "index_rentals_on_event_id"
  add_index "rentals", ["hardware_id"], name: "index_rentals_on_hardware_id"

  create_table "reservations", force: :cascade do |t|
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "seller_id"
    t.integer  "event_id"
    t.integer  "number"
    t.integer  "label_counter"
    t.decimal  "commission_rate",         precision: 3, scale: 2
    t.decimal  "fee",                     precision: 4, scale: 2
    t.integer  "max_items"
    t.boolean  "category_limits_ignored"
  end

  add_index "reservations", ["event_id", "number"], name: "index_reservations_on_event_id_and_number", unique: true
  add_index "reservations", ["event_id"], name: "index_reservations_on_event_id"
  add_index "reservations", ["seller_id"], name: "index_reservations_on_seller_id"

  create_table "reviews", force: :cascade do |t|
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.integer  "registration"
    t.integer  "items"
    t.integer  "print"
    t.integer  "reservation_process"
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
    t.integer  "reservation_id"
  end

  add_index "reviews", ["reservation_id"], name: "index_reviews_on_reservation_id"

  create_table "sellers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.integer  "client_id"
  end

  add_index "sellers", ["client_id"], name: "index_sellers_on_client_id"
  add_index "sellers", ["deleted_at"], name: "index_sellers_on_deleted_at"
  add_index "sellers", ["email", "client_id"], name: "index_sellers_on_email_and_client_id", unique: true, where: "deleted_at IS NULL"
  add_index "sellers", ["token"], name: "index_sellers_on_token", unique: true, where: "deleted_at IS NULL"

  create_table "sold_stock_items", force: :cascade do |t|
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "event_id"
    t.integer  "stock_item_id"
    t.integer  "amount",        null: false
  end

  add_index "sold_stock_items", ["event_id", "stock_item_id"], name: "index_sold_stock_items_on_event_id_and_stock_item_id", unique: true
  add_index "sold_stock_items", ["event_id"], name: "index_sold_stock_items_on_event_id"
  add_index "sold_stock_items", ["stock_item_id"], name: "index_sold_stock_items_on_stock_item_id"

  create_table "stock_items", force: :cascade do |t|
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "description"
    t.decimal  "price",       precision: 5, scale: 2
    t.integer  "number"
    t.string   "code"
    t.integer  "client_id"
  end

  add_index "stock_items", ["client_id"], name: "index_stock_items_on_client_id"
  add_index "stock_items", ["code", "client_id"], name: "index_stock_items_on_code_and_client_id", unique: true
  add_index "stock_items", ["number", "client_id"], name: "index_stock_items_on_number_and_client_id", unique: true

  create_table "stock_message_templates", force: :cascade do |t|
    t.string   "category"
    t.string   "subject"
    t.text     "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "stock_message_templates", ["category"], name: "index_stock_message_templates_on_category", unique: true

  create_table "suspensions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "event_id"
    t.integer  "seller_id"
    t.string   "reason"
  end

  add_index "suspensions", ["event_id", "seller_id"], name: "index_suspensions_on_event_id_and_seller_id", unique: true
  add_index "suspensions", ["event_id"], name: "index_suspensions_on_event_id"
  add_index "suspensions", ["seller_id"], name: "index_suspensions_on_seller_id"

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

  create_table "transaction_items", force: :cascade do |t|
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "transaction_id", null: false
    t.integer  "item_id",        null: false
  end

  add_index "transaction_items", ["item_id"], name: "index_transaction_items_on_item_id"
  add_index "transaction_items", ["transaction_id", "item_id"], name: "index_transaction_items_on_transaction_id_and_item_id", unique: true
  add_index "transaction_items", ["transaction_id"], name: "index_transaction_items_on_transaction_id"

  create_table "transaction_stock_items", force: :cascade do |t|
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "transaction_id", null: false
    t.integer  "stock_item_id",  null: false
    t.integer  "amount"
  end

  add_index "transaction_stock_items", ["stock_item_id"], name: "index_transaction_stock_items_on_stock_item_id"
  add_index "transaction_stock_items", ["transaction_id", "stock_item_id"], name: "index_transaction_stock_items_on_transaction_and_stock_item", unique: true
  add_index "transaction_stock_items", ["transaction_id"], name: "index_transaction_stock_items_on_transaction_id"

  create_table "transactions", force: :cascade do |t|
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "number",     limit: 48, null: false
    t.integer  "event_id"
    t.integer  "kind",                  null: false
    t.string   "zip_code"
  end

  add_index "transactions", ["event_id"], name: "index_transactions_on_event_id"
  add_index "transactions", ["number", "event_id"], name: "index_transactions_on_number_and_event_id", unique: true

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "email",            null: false
    t.string   "crypted_password"
    t.string   "salt"
    t.integer  "client_id"
  end

  add_index "users", ["client_id"], name: "index_users_on_client_id"
  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
