class RenameVisitOi < ActiveRecord::Migration
  def change
    rename_column :visits, :assessment_oi, :assessment_opportunistic_infection
    rename_column :visits, :assessment_nonadherence, :assessment_non_adherence
  end

end
