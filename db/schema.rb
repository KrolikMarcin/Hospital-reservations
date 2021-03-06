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

ActiveRecord::Schema.define(version: 2018_10_29_121022) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "street"
    t.string "house_number"
    t.string "apartment_number"
    t.string "postal_code"
    t.string "city"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_addresses_on_user_id"
  end

  create_table "bill_items", force: :cascade do |t|
    t.bigint "bill_id"
    t.string "description"
    t.decimal "price"
    t.index ["bill_id"], name: "index_bill_items_on_bill_id"
  end

  create_table "bills", force: :cascade do |t|
    t.decimal "amount"
    t.date "payment_date"
    t.boolean "paid", default: false
    t.bigint "reservation_id"
    t.bigint "user_id"
    t.index ["reservation_id"], name: "index_bills_on_reservation_id"
    t.index ["user_id"], name: "index_bills_on_user_id"
  end

  create_table "prescriptions", force: :cascade do |t|
    t.string "medicine"
    t.string "recommendations"
    t.bigint "reservation_id"
    t.bigint "user_id"
    t.index ["reservation_id"], name: "index_prescriptions_on_reservation_id"
    t.index ["user_id"], name: "index_prescriptions_on_user_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.datetime "date_time"
    t.string "doctor_specialization"
    t.string "symptoms"
    t.string "diagnosis"
    t.boolean "status", default: false
  end

  create_table "reservations_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "reservation_id", null: false
    t.index ["user_id", "reservation_id"], name: "index_reservations_users_on_user_id_and_reservation_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "pesel"
    t.boolean "want_email", default: true
    t.string "specialization"
    t.string "role"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "addresses", "users"
  add_foreign_key "bill_items", "bills"
  add_foreign_key "bills", "reservations"
  add_foreign_key "bills", "users"
  add_foreign_key "prescriptions", "reservations"
  add_foreign_key "prescriptions", "users"
end
