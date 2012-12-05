class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :patient_id
      t.datetime :date
      t.string :comments
      t.string :content_type
      t.string :name_string

      t.timestamps
    end
  end
end
