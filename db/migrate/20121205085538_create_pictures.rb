class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.integer :patient_id
      t.string :comment
      t.string :name
      t.string :content_type
      t.datetime :date

      t.timestamps
    end
  end
end
