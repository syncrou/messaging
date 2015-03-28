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

ActiveRecord::Schema.define(version: 20140211131031) do

  create_table "accountings", force: true do |t|
    t.integer  "customer_id"
    t.decimal  "invoiced",    precision: 10, scale: 0
    t.decimal  "paid",        precision: 10, scale: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "group_id"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "controls", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "friendly_name"
  end

  create_table "customers", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "email_fee"
    t.integer  "sms_fee"
    t.boolean  "send_sms"
    t.boolean  "send_email"
    t.integer  "control_id"
    t.string   "phone"
    t.string   "email"
  end

  create_table "deliverables", force: true do |t|
    t.string   "to"
    t.string   "from"
    t.integer  "cents"
    t.integer  "accounting_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sendable_id"
    t.string   "sendable_type"
    t.datetime "delivered_at"
  end

  create_table "emails", force: true do |t|
    t.string   "name"
    t.integer  "customer_id"
    t.datetime "to_deliver"
    t.integer  "repeat"
    t.text     "body"
    t.string   "subject"
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rules", force: true do |t|
    t.text     "rule"
    t.text     "rule_body"
    t.string   "extra_var_1"
    t.string   "extra_var_2"
    t.string   "extra_var_3"
    t.integer  "customer_id"
    t.string   "name"
    t.string   "rule_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "deliver_at"
    t.string   "extra_var_4"
    t.string   "state"
    t.string   "subject"
    t.string   "extra_var_5"
  end

  create_table "sms", force: true do |t|
    t.string   "name"
    t.integer  "customer_id"
    t.datetime "to_deliver"
    t.integer  "repeat"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "admin",                  default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
