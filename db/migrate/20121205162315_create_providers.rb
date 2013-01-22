class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.string :last_name
      t.string :first_name
      t.string :middle_name
      t.string :ident

      t.timestamps
    end
  end
end
