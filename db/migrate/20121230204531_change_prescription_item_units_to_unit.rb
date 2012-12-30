class ChangePrescriptionItemUnitsToUnit < ActiveRecord::Migration
  def up
    rename_column :prescription_items, :units, :unit
  end

  def down
    rename_column :prescription_items, :unit, :units
  end
end
