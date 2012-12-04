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

ActiveRecord::Schema.define(:version => 20121204220422) do

  create_table "diagnoses", :force => true do |t|
    t.string   "name"
    t.string   "label"
    t.string   "synonyms"
    t.string   "comments"
    t.boolean  "show_visits"
    t.integer  "sort_order"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "drugs", :force => true do |t|
    t.string   "name"
    t.string   "drug_class"
    t.string   "drug_subclass"
    t.string   "synonyms"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "patients", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "other_names"
    t.date     "birth_date"
    t.date     "death_date"
    t.boolean  "birth_date_exact"
    t.string   "ident"
    t.string   "sex"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "visits", :force => true do |t|
    t.integer  "patient_id"
    t.datetime "date"
    t.datetime "next_visit"
    t.string   "dx"
    t.string   "dx2"
    t.string   "comments"
    t.float    "weight"
    t.float    "ht"
    t.float    "head_circ"
    t.string   "meds"
    t.boolean  "newdx"
    t.boolean  "newpt"
    t.boolean  "adm"
    t.integer  "sbp"
    t.integer  "dbp"
    t.boolean  "sx_wt_loss"
    t.boolean  "sx_fever"
    t.boolean  "sx_headache"
    t.boolean  "sx_diarrhea"
    t.boolean  "sx_numbness"
    t.boolean  "sx_nausea"
    t.boolean  "sx_rash"
    t.boolean  "sx_vomiting"
    t.boolean  "sx_cough"
    t.boolean  "sx_night_sweats"
    t.boolean  "sx_visual_prob_new"
    t.boolean  "sx_pain_swallowing"
    t.boolean  "sx_short_breath"
    t.string   "sx_other"
    t.boolean  "dx_hiv"
    t.boolean  "dx_tb_pulm"
    t.boolean  "dx_pneumonia"
    t.boolean  "dx_malaria"
    t.boolean  "dx_uri"
    t.boolean  "dx_acute_ge"
    t.boolean  "dx_otitis_media_acute"
    t.boolean  "dx_otitis_media_chronic"
    t.boolean  "dx_thrush"
    t.boolean  "dx_tinea_capitis"
    t.boolean  "dx_scabies"
    t.boolean  "dx_parotitis"
    t.boolean  "dx_dysentery"
    t.boolean  "scheduled"
  end

end
