class ChangePatientBirthDate < ActiveRecord::Migration
  def up
    change_column :patients, :birth_date, :datetime
  end

  def down
    change_column :patients, :birth_date, :date
  end
end
