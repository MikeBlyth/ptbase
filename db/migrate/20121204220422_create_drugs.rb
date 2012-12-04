class CreateDrugs < ActiveRecord::Migration
  def change
    create_table :drugs do |t|
      t.integer :id
      t.string :name
      t.string :drug_class
      t.string :drug_subclass
      t.string :synonyms
      t.timestamps
    end
  end
end
