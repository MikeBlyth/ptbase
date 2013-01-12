class CreateLabServices < ActiveRecord::Migration
  def change
    create_table :lab_services do |t|
      t.string :name
      t.string :abbrev
      t.string :unit
      t.string :normal_range
      t.integer :lab_group_id
      t.float :cost
      t.string :comments

      t.timestamps
    end
  end
end
