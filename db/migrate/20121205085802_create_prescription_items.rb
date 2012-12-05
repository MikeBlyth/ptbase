class CreatePrescriptionItems < ActiveRecord::Migration
  def change
    create_table :prescription_items do |t|
      t.string :drug
      t.integer :prescription_id
      t.float :dose
      t.string :units
      t.string :route
      t.integer :interval
      t.boolean :use_liquid
      t.integer :liquid
      t.integer :duration
      t.string :other_description
      t.string :other_instructions
      t.boolean :filled

      t.timestamps
    end
  end
end
