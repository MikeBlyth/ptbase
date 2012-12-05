class CreateAdmissions < ActiveRecord::Migration
  def change
    create_table :admissions do |t|
      t.integer :patient_id
      t.string :bed
      t.string :ward
      t.string :diagnosis_1
      t.string :diagnosis_2
      t.string :meds
      t.float :weight_admission
      t.float :weight_discharge
      t.datetime :admission_date
      t.datetime :discharge_date
      t.string :discharge_status
      t.string :comments

      t.timestamps
    end
  end
end
