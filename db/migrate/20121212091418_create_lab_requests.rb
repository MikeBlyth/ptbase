class CreateLabRequests < ActiveRecord::Migration
  def change
    create_table :lab_requests do |t|
      t.integer :patient_id
      t.datetime :date
      t.boolean :hct
      t.boolean :fbc
      t.boolean :malaria
      t.boolean :hiv_rapid
      t.boolean :urinalysis
      t.boolean :blood_glucose
      t.boolean :cd4

      t.timestamps
    end
  end
end
