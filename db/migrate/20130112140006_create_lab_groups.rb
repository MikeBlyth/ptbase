class CreateLabGroups < ActiveRecord::Migration
  def change
    create_table :lab_groups do |t|
      t.string :name
      t.string :abbrev

      t.timestamps
    end
  end
end
