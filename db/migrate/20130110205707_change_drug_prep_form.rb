class ChangeDrugPrepForm < ActiveRecord::Migration
  def change
    rename_column :drug_preps, :form, :xform
  end
end
