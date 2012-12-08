class RenamePrescriptionVoided < ActiveRecord::Migration
  def change
    rename_column :prescriptions, :voided, :void
  end
end
