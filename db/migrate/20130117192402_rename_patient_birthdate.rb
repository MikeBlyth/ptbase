class RenamePatientBirthdate < ActiveRecord::Migration
# Commented out as a way of bypassing this migration
  def up
#    rename_column :patients, :birth_date, :birth_datetime
  end

  def down
#    rename_column :patients, :birth_datetime, :birth_date
  end
end
