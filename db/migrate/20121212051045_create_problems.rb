class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.string :description
      t.datetime :date
      t.datetime :resolved
      t.integer :patient_id

      t.timestamps
    end
  end
end
