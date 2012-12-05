class CreateDrugPreps < ActiveRecord::Migration
  def change
    create_table :drug_preps do |t|
      t.integer :drug_id
      t.string :form
      t.string :strength
      t.float :mult
      t.string :quantity
      t.float :buy_price
      t.float :stock
      t.string :synonyms

      t.timestamps
    end
  end
end
