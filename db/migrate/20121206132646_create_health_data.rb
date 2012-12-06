class CreateHealthData < ActiveRecord::Migration
  def change
    create_table :health_data do |t|
      t.integer :patient_id
      t.string :hiv_status
      t.string :maternal_hiv_status
      t.string :allergies
      t.string :comments

      t.timestamps
    end
  end
end
