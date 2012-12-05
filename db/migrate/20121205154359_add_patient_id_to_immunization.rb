class AddPatientIdToImmunization < ActiveRecord::Migration
  def change
    add_column :immunizations, :patient_id, :integer
    add_column :immunizations, :date, :date
  end
end
