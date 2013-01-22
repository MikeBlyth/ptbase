class AddLevelsToProvider < ActiveRecord::Migration
  def change
    add_column :providers, :title, :string
    add_column :providers, :position, :string
    add_column :providers, :degree, :string
    rename_column :providers, :middle_name, :middle_name
    rename_column :patients, :middle_name, :middle_name
  end
end
