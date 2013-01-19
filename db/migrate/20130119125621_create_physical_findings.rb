class CreatePhysicalFindings < ActiveRecord::Migration
  def change
    create_table :physicals do |t|
      t.string :name
      t.string :label
      t.string :synonyms
      t.string :comments
      t.integer :sort_order
      t.boolean :show_visits

      t.timestamps
    end
  end
end
