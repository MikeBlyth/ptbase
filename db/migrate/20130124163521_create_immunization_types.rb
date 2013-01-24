class CreateImmunizationTypes < ActiveRecord::Migration
  def change
    #drop_table :immunizations
    create_table :immunizations do |t|
      t.integer :immunization_type_id
      t.integer :patient_id
      t.datetime    :date
      t.integer :provider_id
      t.string  :comments
    end
    create_table :immunization_types do |t|
      t.string :name
      t.string :abbrev
      t.string :notes
      t.timestamps
    end
  end
end
