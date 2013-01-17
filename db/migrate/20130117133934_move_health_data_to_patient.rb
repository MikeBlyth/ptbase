class MoveHealthDataToPatient < ActiveRecord::Migration
  def change
    add_column :patients, :hiv_status, :string
    add_column :patients, :maternal_hiv_status, :string
    add_column :patients, :allergies , :string
    add_column :patients, :hemoglobin_type , :string
    add_column :patients, :comments , :string

    remove_column :health_data, :hiv_status
    remove_column :health_data, :maternal_hiv_status
    remove_column :health_data, :allergies
    remove_column :health_data, :hemoglobin_type
    remove_column :health_data, :comments
  end
end
