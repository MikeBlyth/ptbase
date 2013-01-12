class RecreateWorkLabRequest < ActiveRecord::Migration
  def up
    drop_table :lab_requests
    create_table :lab_requests do |t|
      t.integer :provider_id
      t.integer :patient_id
      t.string :comments
      t.timestamps
    end
  end


  def down
  end
end
