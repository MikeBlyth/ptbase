class AddResidenceToPatient < ActiveRecord::Migration
  def change
    add_column :patients, :residence, :string
    add_column :patients, :phone, :string
    add_column :patients, :caregiver, :string
  end
end
