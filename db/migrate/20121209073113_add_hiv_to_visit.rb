class AddHivToVisit < ActiveRecord::Migration
  def change
    add_column :visits, :hiv_stage, :string
    add_column :visits, :arv_status, :string
    add_column :visits, :anti_tb_status, :string
  end
end
