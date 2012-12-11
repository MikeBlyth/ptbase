class ImmunizationRedo < ActiveRecord::Migration
  def up
    drop_table :immunizations
    create_table :immunizations do |t|
      t.integer :patient_id
      t.date :bcg
      t.date :opv1
      t.date :opv2
      t.date :opv3
      t.date :opv4
      t.date :dpt1
      t.date :dpt2
      t.date :dpt3
      t.date :dpt4
      t.date :tt1
      t.date :tt2
      t.date :tt3
      t.date :tt4
      t.date :hepb1
      t.date :hepb2
      t.date :hepb3
      t.date :hepb4
      t.date :measles1
      t.date :measles2
      t.date :mmr1
      t.date :mmr2
      t.date :hib1
      t.date :hib2
      t.date :hib3
      t.date :hib4
      t.date :mening
      t.date :pneumo

      t.timestamps
    end
  end


  def down          
    drop_table :immunizations
    create_table :immunizations do |t|
      t.integer :provider_id
      t.integer :patient_id
      t.string :bcg
      t.string :opv1
      t.string :opv2
      t.string :opv3
      t.string :opv4
      t.string :dpt1
      t.string :dpt2
      t.string :dpt3
      t.string :dpt4
      t.string :tt1
      t.string :tt2
      t.string :tt3
      t.string :tt4
      t.string :hepb1
      t.string :hepb2
      t.string :hepb3
      t.string :hepb4
      t.string :measles1
      t.string :measles2
      t.string :mmr1
      t.string :mmr2
      t.string :hib1
      t.string :hib2
      t.string :hib3
      t.string :hib4
      t.string :mening
      t.string :pneumo

      t.timestamps
    end

  end
end


