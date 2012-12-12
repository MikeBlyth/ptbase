class AddArvsToVisit < ActiveRecord::Migration
  def change
    add_column :visits, :reg_zidovudine, :boolean
    add_column :visits, :reg_stavudine, :boolean
    add_column :visits, :reg_lamivudine, :boolean
    add_column :visits, :reg_didanosine, :boolean
    add_column :visits, :reg_nevirapine, :boolean
    add_column :visits, :reg_efavirenz, :boolean
    add_column :visits, :reg_kaletra, :boolean
  end
end
