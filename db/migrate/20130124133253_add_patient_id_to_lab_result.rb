class AddPatientIdToLabResult < ActiveRecord::Migration
  def change
    add_column :lab_results, :patient_id, :integer
  end
end
