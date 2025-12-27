# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2025_12_27_135548) do

  create_table "bills", force: :cascade do |t|
    t.integer "event_id"
    t.string "number"
    t.binary "document", limit: 1000000
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_bills_on_event_id"
    t.index ["number"], name: "index_bills_on_number", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.boolean "donation_enforced"
    t.integer "max_items_per_seller"
    t.datetime "deleted_at"
    t.integer "parent_id"
    t.integer "client_id"
    t.integer "size_option", default: 0
    t.boolean "gender"
    t.index ["client_id"], name: "index_categories_on_client_id"
    t.index ["deleted_at"], name: "index_categories_on_deleted_at"
    t.index ["name"], name: "index_categories_on_name", where: "deleted_at IS NULL"
  end

  create_table "clients", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "key", limit: 40
    t.string "prefix", limit: 4
    t.string "name", limit: 80
    t.string "short_name", limit: 60
    t.string "logo", limit: 40
    t.string "address"
    t.string "invoice_address"
    t.text "intro"
    t.text "outro"
    t.string "mail_address", limit: 128
    t.text "terms"
    t.decimal "reservation_fee", precision: 4, scale: 2
    t.decimal "commission_rate", precision: 3, scale: 2
    t.decimal "price_precision", precision: 3, scale: 2
    t.boolean "donation_of_unsold_items"
    t.boolean "donation_of_unsold_items_default"
    t.boolean "reservation_by_seller_forbidden"
    t.boolean "reservation_numbers_assignable"
    t.integer "auto_reservation_numbers_start"
    t.boolean "import_items_allowed"
    t.boolean "import_item_code_enabled"
    t.boolean "precise_bill_amounts"
    t.boolean "gates"
    t.string "locked"
    t.index ["key"], name: "index_clients_on_key", unique: true
    t.index ["prefix"], name: "index_clients_on_prefix", unique: true
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.index ["priority", "run_at"], name: "index_delayed_jobs_on_priority_and_run_at"
  end

  create_table "emails", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "seller_id"
    t.string "to"
    t.string "subject"
    t.text "body"
    t.string "from"
    t.string "cc"
    t.string "message_id"
    t.boolean "read"
    t.string "kind"
    t.integer "parent_id"
    t.index ["message_id"], name: "index_emails_on_message_id", unique: true
    t.index ["parent_id"], name: "index_emails_on_parent_id"
    t.index ["read"], name: "index_emails_on_read"
    t.index ["seller_id"], name: "index_emails_on_seller_id"
  end

  create_table "events", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.text "details"
    t.integer "max_reservations"
    t.integer "max_items_per_reservation"
    t.boolean "confirmed"
    t.datetime "reservation_start"
    t.datetime "reservation_end"
    t.integer "kind"
    t.decimal "price_precision", precision: 3, scale: 2
    t.decimal "commission_rate", precision: 3, scale: 2
    t.decimal "reservation_fee", precision: 4, scale: 2
    t.boolean "donation_of_unsold_items_enabled"
    t.string "token"
    t.integer "max_reservations_per_seller"
    t.boolean "reservation_fees_payed_in_advance"
    t.integer "client_id"
    t.integer "number"
    t.boolean "support_system_enabled"
    t.boolean "supporters_can_retire"
    t.boolean "precise_bill_amounts"
    t.boolean "gates"
    t.decimal "price_factor", precision: 3, scale: 2
    t.boolean "reservation_fee_based_on_item_count"
    t.index ["client_id"], name: "index_events_on_client_id"
    t.index ["number", "client_id"], name: "index_events_on_number_and_client_id", unique: true
    t.index ["token"], name: "index_events_on_token", unique: true
  end

  create_table "hardware", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.decimal "price", precision: 5, scale: 1
    t.index ["description"], name: "index_hardware_on_description", unique: true
  end

  create_table "items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category_id"
    t.string "description"
    t.string "size"
    t.decimal "price", precision: 5, scale: 1
    t.integer "reservation_id"
    t.integer "number"
    t.string "code"
    t.datetime "sold"
    t.boolean "donation"
    t.integer "gender"
    t.datetime "checked_in"
    t.datetime "checked_out"
    t.index ["category_id"], name: "index_items_on_category_id"
    t.index ["reservation_id", "code"], name: "index_items_on_reservation_id_and_code", unique: true
    t.index ["reservation_id", "number"], name: "index_items_on_reservation_id_and_number", unique: true
    t.index ["reservation_id"], name: "index_items_on_reservation_id"
  end

  create_table "message_templates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.string "subject"
    t.text "body"
    t.integer "client_id"
    t.index ["category", "client_id"], name: "index_message_templates_on_category_and_client_id", unique: true
    t.index ["client_id"], name: "index_message_templates_on_client_id"
  end

  create_table "messages", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "category"
    t.integer "event_id"
    t.integer "scheduled_count"
    t.integer "sent_count"
    t.index ["category", "event_id"], name: "index_messages_on_category_and_event_id", unique: true
    t.index ["event_id"], name: "index_messages_on_event_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "event_id"
    t.integer "seller_id"
    t.index ["event_id", "seller_id"], name: "index_notifications_on_event_id_and_seller_id", unique: true
    t.index ["event_id"], name: "index_notifications_on_event_id"
    t.index ["seller_id"], name: "index_notifications_on_seller_id"
  end

  create_table "rentals", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "hardware_id"
    t.integer "event_id"
    t.integer "amount"
    t.index ["event_id", "hardware_id"], name: "index_rentals_on_event_id_and_hardware_id", unique: true
    t.index ["event_id"], name: "index_rentals_on_event_id"
    t.index ["hardware_id"], name: "index_rentals_on_hardware_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "seller_id"
    t.integer "event_id"
    t.integer "number"
    t.integer "label_counter"
    t.decimal "commission_rate", precision: 3, scale: 2
    t.decimal "fee", precision: 4, scale: 2
    t.integer "max_items"
    t.boolean "category_limits_ignored"
    t.index ["event_id", "number"], name: "index_reservations_on_event_id_and_number", unique: true
    t.index ["event_id"], name: "index_reservations_on_event_id"
    t.index ["seller_id"], name: "index_reservations_on_seller_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "registration"
    t.integer "items"
    t.integer "print"
    t.integer "reservation_process"
    t.integer "mailing"
    t.integer "content"
    t.integer "design"
    t.integer "support"
    t.integer "handover"
    t.integer "payoff"
    t.integer "sale"
    t.integer "organization"
    t.integer "total"
    t.string "source"
    t.boolean "recommend"
    t.text "to_improve"
    t.integer "reservation_id"
    t.index ["reservation_id"], name: "index_reviews_on_reservation_id", unique: true
  end

  create_table "sellers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "street"
    t.string "zip_code"
    t.string "city"
    t.string "email"
    t.string "phone"
    t.string "token"
    t.boolean "mailing"
    t.boolean "active"
    t.datetime "deleted_at"
    t.integer "client_id"
    t.integer "default_reservation_number"
    t.index ["client_id", "default_reservation_number"], name: "index_sellers_on_client_id_and_default_reservation_number", unique: true
    t.index ["client_id"], name: "index_sellers_on_client_id"
    t.index ["deleted_at"], name: "index_sellers_on_deleted_at"
    t.index ["email", "client_id"], name: "index_sellers_on_email_and_client_id", unique: true, where: "deleted_at IS NULL"
    t.index ["token"], name: "index_sellers_on_token", unique: true, where: "deleted_at IS NULL"
  end

  create_table "sizes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "value"
    t.integer "category_id"
    t.index ["category_id"], name: "index_sizes_on_category_id"
    t.index ["value", "category_id"], name: "index_sizes_on_value_and_category_id", unique: true
  end

  create_table "sold_stock_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "event_id"
    t.integer "stock_item_id"
    t.integer "amount", null: false
    t.index ["event_id", "stock_item_id"], name: "index_sold_stock_items_on_event_id_and_stock_item_id", unique: true
    t.index ["event_id"], name: "index_sold_stock_items_on_event_id"
    t.index ["stock_item_id"], name: "index_sold_stock_items_on_stock_item_id"
  end

  create_table "stock_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.decimal "price", precision: 5, scale: 2
    t.integer "number"
    t.string "code"
    t.integer "client_id"
    t.index ["client_id"], name: "index_stock_items_on_client_id"
    t.index ["code", "client_id"], name: "index_stock_items_on_code_and_client_id", unique: true
    t.index ["number", "client_id"], name: "index_stock_items_on_number_and_client_id", unique: true
  end

  create_table "stock_message_templates", force: :cascade do |t|
    t.string "category"
    t.string "subject"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category"], name: "index_stock_message_templates_on_category", unique: true
  end

  create_table "support_types", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.text "description"
    t.integer "capacity"
    t.integer "event_id"
    t.index ["event_id"], name: "index_support_types_on_event_id"
  end

  create_table "supporters", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "support_type_id"
    t.integer "seller_id"
    t.string "comments"
    t.index ["seller_id"], name: "index_supporters_on_seller_id"
    t.index ["support_type_id", "seller_id"], name: "index_supporters_on_support_type_id_and_seller_id", unique: true
    t.index ["support_type_id"], name: "index_supporters_on_support_type_id"
  end

  create_table "suspensions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "event_id"
    t.integer "seller_id"
    t.string "reason"
    t.index ["event_id", "seller_id"], name: "index_suspensions_on_event_id_and_seller_id", unique: true
    t.index ["event_id"], name: "index_suspensions_on_event_id"
    t.index ["seller_id"], name: "index_suspensions_on_seller_id"
  end

  create_table "time_periods", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "kind"
    t.integer "event_id"
    t.datetime "min"
    t.datetime "max"
    t.index ["event_id"], name: "index_time_periods_on_event_id"
    t.index ["kind"], name: "index_time_periods_on_kind"
  end

  create_table "transaction_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "transaction_id", null: false
    t.integer "item_id", null: false
    t.index ["item_id"], name: "index_transaction_items_on_item_id"
    t.index ["transaction_id", "item_id"], name: "index_transaction_items_on_transaction_id_and_item_id", unique: true
    t.index ["transaction_id"], name: "index_transaction_items_on_transaction_id"
  end

  create_table "transaction_stock_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "transaction_id", null: false
    t.integer "stock_item_id", null: false
    t.integer "amount"
    t.index ["stock_item_id"], name: "index_transaction_stock_items_on_stock_item_id"
    t.index ["transaction_id", "stock_item_id"], name: "index_transaction_stock_items_on_transaction_and_stock_item", unique: true
    t.index ["transaction_id"], name: "index_transaction_stock_items_on_transaction_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "number", limit: 48, null: false
    t.integer "event_id"
    t.integer "kind", null: false
    t.string "zip_code"
    t.index ["event_id"], name: "index_transactions_on_event_id"
    t.index ["number", "event_id"], name: "index_transactions_on_number_and_event_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", null: false
    t.string "crypted_password"
    t.string "salt"
    t.integer "client_id"
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.datetime "reset_password_email_sent_at"
    t.integer "access_count_to_reset_password_page", default: 0
    t.string "name"
    t.index ["client_id"], name: "index_users_on_client_id"
    t.index ["email", "client_id"], name: "index_users_on_email_and_client_id", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

  add_foreign_key "bills", "events"
  add_foreign_key "categories", "categories", column: "parent_id"
  add_foreign_key "emails", "sellers"
  add_foreign_key "message_templates", "clients"
  add_foreign_key "messages", "events"
  add_foreign_key "rentals", "hardware"
  add_foreign_key "reviews", "reservations"
  add_foreign_key "sizes", "categories"
  add_foreign_key "sold_stock_items", "events"
  add_foreign_key "sold_stock_items", "stock_items"
  add_foreign_key "support_types", "events"
  add_foreign_key "supporters", "sellers"
  add_foreign_key "supporters", "support_types"
  add_foreign_key "suspensions", "events"
  add_foreign_key "suspensions", "sellers"
  add_foreign_key "transaction_items", "items"
  add_foreign_key "transaction_items", "transactions"
  add_foreign_key "transaction_stock_items", "stock_items"
  add_foreign_key "transaction_stock_items", "transactions"
  add_foreign_key "transactions", "events"
end
