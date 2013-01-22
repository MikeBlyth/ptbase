class CreatePatients < ActiveRecord::Migration
  def change
    create_table :patients do |t|
      t.string :first_name
      t.string :last_name
      t.string :middle_name
      t.date :birth_date
      t.date :death_date
      t.boolean :birth_date_exact
      t.string :ident
      t.string :sex

      t.timestamps
    end
  end
end
