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

ActiveRecord::Schema.define(:version => 20121216130832) do

  create_table "admissions", :force => true do |t|
    t.integer  "patient_id"
    t.string   "bed"
    t.string   "ward"
    t.string   "diagnosis_1"
    t.string   "diagnosis_2"
    t.string   "meds"
    t.float    "weight_admission"
    t.float    "weight_discharge"
    t.datetime "date"
    t.datetime "discharge_date"
    t.string   "discharge_status"
    t.string   "comments"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.integer  "provider_id"
  end

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

  create_table "drug_preps", :force => true do |t|
    t.integer  "drug_id"
    t.string   "form"
    t.string   "strength"
    t.float    "mult"
    t.string   "quantity"
    t.float    "buy_price"
    t.float    "stock"
    t.string   "synonyms"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "drugs", :force => true do |t|
    t.string   "name"
    t.string   "drug_class"
    t.string   "drug_subclass"
    t.string   "synonyms"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "health_data", :force => true do |t|
    t.integer  "patient_id"
    t.string   "hiv_status"
    t.string   "maternal_hiv_status"
    t.string   "allergies"
    t.string   "comments"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "hemoglobin_type"
  end

  create_table "icd9s", :force => true do |t|
    t.string   "icd9"
    t.string   "mod"
    t.string   "description"
    t.string   "short_descr"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "immunizations", :force => true do |t|
    t.integer  "patient_id"
    t.date     "bcg"
    t.date     "opv1"
    t.date     "opv2"
    t.date     "opv3"
    t.date     "opv4"
    t.date     "dpt1"
    t.date     "dpt2"
    t.date     "dpt3"
    t.date     "dpt4"
    t.date     "tt1"
    t.date     "tt2"
    t.date     "tt3"
    t.date     "tt4"
    t.date     "hepb1"
    t.date     "hepb2"
    t.date     "hepb3"
    t.date     "hepb4"
    t.date     "measles1"
    t.date     "measles2"
    t.date     "mmr1"
    t.date     "mmr2"
    t.date     "hib1"
    t.date     "hib2"
    t.date     "hib3"
    t.date     "hib4"
    t.date     "mening"
    t.date     "pneumo"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "lab_requests", :force => true do |t|
    t.integer  "patient_id"
    t.datetime "date"
    t.boolean  "hct"
    t.boolean  "fbc"
    t.boolean  "malaria"
    t.boolean  "hiv_rapid"
    t.boolean  "urinalysis"
    t.boolean  "blood_glucose"
    t.boolean  "cd4"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "labs", :force => true do |t|
    t.integer  "patient_id"
    t.string   "categories"
    t.datetime "date"
    t.integer  "wbc"
    t.integer  "neut"
    t.integer  "lymph"
    t.integer  "bands"
    t.integer  "eos"
    t.integer  "hct"
    t.float    "retic"
    t.integer  "esr"
    t.integer  "platelets"
    t.string   "malaria_smear"
    t.integer  "csf_rbc"
    t.integer  "csf_wbc"
    t.integer  "csf_lymph"
    t.integer  "csf_neut"
    t.integer  "csf_protein"
    t.string   "csf_glucose"
    t.string   "csf_culture"
    t.integer  "blood_glucose"
    t.string   "urinalysis"
    t.float    "bili"
    t.string   "hiv_screen"
    t.string   "hiv_antigen"
    t.string   "wb"
    t.string   "mantoux"
    t.string   "hb_elect"
    t.string   "other"
    t.float    "creat"
    t.integer  "cd4"
    t.integer  "cd4pct"
    t.integer  "amylase"
    t.integer  "sgpt"
    t.integer  "sgot"
    t.boolean  "hbsag"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "provider_id"
    t.string   "comment_hct"
    t.string   "comment_cd4"
  end

  create_table "patients", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "other_names"
    t.datetime "birth_date"
    t.date     "death_date"
    t.boolean  "birth_date_exact"
    t.string   "ident"
    t.string   "sex"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "photos", :force => true do |t|
    t.integer  "patient_id"
    t.datetime "date"
    t.string   "comments"
    t.string   "content_type"
    t.string   "name_string"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "pictures", :force => true do |t|
    t.integer  "patient_id"
    t.string   "comment"
    t.string   "name"
    t.string   "content_type"
    t.datetime "date"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "prescription_items", :force => true do |t|
    t.string   "drug"
    t.integer  "prescription_id"
    t.float    "dose"
    t.string   "units"
    t.string   "route"
    t.integer  "interval"
    t.boolean  "use_liquid"
    t.integer  "liquid"
    t.integer  "duration"
    t.string   "other_description"
    t.string   "other_instructions"
    t.boolean  "filled"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "prescriptions", :force => true do |t|
    t.integer  "patient_id"
    t.integer  "provider_id"
    t.datetime "date"
    t.boolean  "filled"
    t.boolean  "confirmed"
    t.boolean  "void"
    t.float    "weight"
    t.float    "height"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "problems", :force => true do |t|
    t.string   "description"
    t.datetime "date"
    t.datetime "resolved"
    t.integer  "patient_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "providers", :force => true do |t|
    t.string   "last_name"
    t.string   "first_name"
    t.string   "other_names"
    t.string   "ident"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
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
    t.string   "username"
    t.string   "name"
    t.string   "full_name"
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
    t.float    "height"
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
    t.integer  "provider_id"
    t.string   "hiv_stage"
    t.string   "arv_status"
    t.string   "anti_tb_status"
    t.boolean  "reg_zidovudine"
    t.boolean  "reg_stavudine"
    t.boolean  "reg_lamivudine"
    t.boolean  "reg_didanosine"
    t.boolean  "reg_nevirapine"
    t.boolean  "reg_efavirenz"
    t.boolean  "reg_kaletra"
    t.text     "hpi"
    t.float    "temperature"
    t.text     "development"
    t.text     "assessment"
    t.text     "plan"
    t.float    "mid_arm_circ"
    t.integer  "resp_rate"
    t.integer  "heart_rate"
    t.boolean  "sx_ear_pain_disch"
    t.text     "phys_exam"
    t.boolean  "diet_breast"
    t.boolean  "diet_breastmilk_substitute"
    t.boolean  "diet_pap"
    t.boolean  "diet_solids"
    t.boolean  "assessment_stable"
    t.boolean  "assessment_oi"
    t.boolean  "assessment_drug_toxicity"
    t.boolean  "assessment_nonadherence"
    t.integer  "arv_missed"
    t.integer  "arv_missed_week"
  end

end
