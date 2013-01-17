class DropHealthData < ActiveRecord::Migration
  def up
    drop_table :health_data
  end

  def down
  end
end
