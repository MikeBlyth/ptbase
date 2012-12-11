class RenameColumnPresciption < ActiveRecord::Migration
  def change
    rename_column :prescriptions, :prescriber_id, :provider_id
  end

end
