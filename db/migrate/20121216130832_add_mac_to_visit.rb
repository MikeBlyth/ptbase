class AddMacToVisit < ActiveRecord::Migration
  def change
    add_column :visits, :mid_arm_circ, :float
    add_column :visits, :resp_rate, :integer
    add_column :visits, :heart_rate, :integer
    add_column :visits, :sx_ear_pain_disch, :boolean
    add_column :visits, :phys_exam, :text
    add_column :visits, :diet_breast, :boolean
    add_column :visits, :diet_breastmilk_substitute, :boolean
    add_column :visits, :diet_pap, :boolean
    add_column :visits, :diet_solids, :boolean
    add_column :visits, :assessment_stable, :boolean
    add_column :visits, :assessment_oi, :boolean
    add_column :visits, :assessment_drug_toxicity, :boolean
    add_column :visits, :assessment_nonadherence, :boolean
    add_column :visits, :arv_missed, :integer
    add_column :visits, :arv_missed_week, :integer
  end
end
