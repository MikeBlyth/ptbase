class ChangePrescriptionItemDose < ActiveRecord::Migration
  def up
    change_column :prescription_items, :dose, :string
  end

  def down
    change_column :prescription_items, :dose, :float
  end
end
