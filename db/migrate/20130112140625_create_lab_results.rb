class CreateLabResults < ActiveRecord::Migration
  def change
    create_table :lab_results do |t|
      t.integer :lab_request_id
      t.integer :lab_service_id
      t.string :result
      t.datetime :date
      t.string :status
      t.boolean :abnormal
      t.boolean :panic
      t.string :comments
      t.timestamps
    end
  end
end
