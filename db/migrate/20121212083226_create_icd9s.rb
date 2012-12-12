class CreateIcd9s < ActiveRecord::Migration
  def change
    create_table :icd9s do |t|
      t.string :icd9
      t.string :mod
      t.string :description
      t.string :short_descr

      t.timestamps
    end
  end
end
