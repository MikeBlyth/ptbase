class AddFieldsToVisit < ActiveRecord::Migration
  def change
    add_column :visits, :symptoms, :hstore
    add_column :visits, :exam, :hstore
    add_column :visits, :diagnoses, :hstore
  end
end
