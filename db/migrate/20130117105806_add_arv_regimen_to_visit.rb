class AddArvRegimenToVisit < ActiveRecord::Migration
  def change
    add_column :visits, :arv_regimen, :string
  end
end
