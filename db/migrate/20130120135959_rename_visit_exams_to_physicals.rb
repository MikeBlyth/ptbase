class RenameVisitExamsToPhysicals < ActiveRecord::Migration
  def change
    rename_column :visits, :exam, :physical
  end
end
