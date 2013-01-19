class CreateSymptoms < ActiveRecord::Migration
  def change
    create_table :symptoms do |t|
      t.integer :id
      t.string :name
      t.string :label
      t.string :synonyms
      t.string :comments
      t.boolean :show_visits
      t.integer :sort_order
      t.timestamps
    end
  end
end
