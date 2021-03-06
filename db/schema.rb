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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121203224736) do

  create_table "assets", :force => true do |t|
    t.string   "asset_file_name"
    t.integer  "asset_file_size"
    t.string   "asset_content_type"
    t.datetime "asset_updated_at"
    t.integer  "survey_id"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.boolean  "processed",          :default => false
  end

  add_index "assets", ["survey_id"], :name => "index_assets_on_survey_id"

  create_table "booking_details", :force => true do |t|
    t.integer  "booking_id"
    t.integer  "rank"
    t.integer  "charge_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "booking_details", ["booking_id", "rank"], :name => "index_booking_details_on_booking_id_and_rank", :unique => true

  create_table "bookings", :force => true do |t|
    t.string   "zip_code"
    t.date     "booking_date"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.integer  "survey_id"
    t.string   "city"
    t.string   "state"
    t.integer  "score"
  end

  add_index "bookings", ["city"], :name => "index_bookings_on_city"
  add_index "bookings", ["score"], :name => "index_bookings_on_score"
  add_index "bookings", ["state"], :name => "index_bookings_on_state"
  add_index "bookings", ["survey_id"], :name => "index_bookings_on_survey_id"
  add_index "bookings", ["zip_code"], :name => "index_bookings_on_zip_code"

  create_table "charge_aliases", :force => true do |t|
    t.string   "alias"
    t.integer  "charge_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "charge_aliases", ["alias"], :name => "index_charge_aliases_on_alias", :unique => true

  create_table "charge_types", :force => true do |t|
    t.integer  "score"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "description"
  end

  create_table "charges", :force => true do |t|
    t.integer  "charge_type_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "filter_criteria", :force => true do |t|
    t.integer  "survey_id"
    t.integer  "charge_type_id"
    t.integer  "significance"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "filter_criteria", ["survey_id", "charge_type_id"], :name => "index_filter_criteria_on_survey_id_and_charge_type_id", :unique => true
  add_index "filter_criteria", ["survey_id"], :name => "index_filter_criteria_on_survey_id"

  create_table "permissions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "thing_id"
    t.string   "thing_type"
    t.string   "action"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "surveys", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "surveys", ["user_id"], :name => "index_surveys_on_user_id"

  create_table "user_configurations", :force => true do |t|
    t.integer  "user_id"
    t.string   "booking_date_field_name", :default => "booking_date"
    t.string   "zip_code_field_name",     :default => "zip_code"
    t.string   "city_field_name",         :default => "city"
    t.string   "state_field_name",        :default => "state"
    t.string   "charge_field_prefix",     :default => "charge_"
    t.integer  "num_charges",             :default => 5
    t.datetime "created_at",                                          :null => false
    t.datetime "updated_at",                                          :null => false
  end

  add_index "user_configurations", ["user_id"], :name => "index_user_configurations_on_user_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.boolean  "admin",                  :default => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
