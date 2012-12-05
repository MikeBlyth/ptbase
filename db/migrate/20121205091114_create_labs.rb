class CreateLabs < ActiveRecord::Migration
  def change
    create_table :labs do |t|
      t.integer :patient_id
    t.string :categories
    t.datetime :date
    t.integer :wbc
    t.integer :neut
    t.integer :lymph
    t.integer :bands
    t.integer :eos
    t.integer :hct
    t.float :retic
    t.integer :esr
    t.integer :platelets
    t.string :malaria_smear
    t.integer :csf_rbc
    t.integer :csf_wbc
    t.integer :csf_lymph
    t.integer :csf_neut
    t.integer :csf_protein
    t.string :csf_glucose
    t.string :csf_culture
    t.integer :blood_glucose
    t.string :urinalysis
    t.float :bili
    t.string :hiv_screen
    t.string :hiv_antigen
    t.string :wb
    t.string :mantoux
    t.string :hb_elect
    t.string :other
    t.float :creat
    t.integer :cd4
    t.integer :cd4pct
    t.integer :amylase
    t.integer :sgpt
    t.integer :sgot
    t.boolean :hbsag

      t.timestamps
    end
  end
end
