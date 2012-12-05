class CreateImmunizations < ActiveRecord::Migration
  def change
    create_table :immunizations do |t|
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
