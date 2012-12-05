class CreatePrescriptions < ActiveRecord::Migration
  def change
    create_table :prescriptions do |t|
      t.integer :patient_id
      t.integer :prescriber_id
      t.datetime :date
      t.boolean :filled
      t.boolean :confirmed
      t.boolean :voided
      t.float :weight
      t.float :height

      t.timestamps
    end
  end
end
