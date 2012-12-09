class ChangeVisitHtToHeight < ActiveRecord::Migration
  def change
    rename_column :visits, :ht, :height
  end
end
