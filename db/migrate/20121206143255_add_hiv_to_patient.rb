class AddHivToPatient < ActiveRecord::Migration
  def change
    add_column :patients, :hiv_status, :string
    add_column :patients, :maternal_hiv_status, :string
    add_column :patients, :allergies, :string
    add_column :patients, :comments, :text
  end
end
