class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
        t.integer :patient_id
        t.datetime :date
        t.datetime :next_visit
        t.string :dx
        t.string :dx2
        t.string :comments
        t.float :weight
        t.float :ht
        t.float :head_circ
        t.string :meds
        t.boolean :newdx
        t.boolean :newpt
        t.boolean :adm
        t.integer :id
        t.integer :sbp
        t.integer :dbp
        t.boolean :sx_wt_loss
        t.boolean :sx_fever
        t.boolean :sx_headache
        t.boolean :sx_diarrhea
        t.boolean :sx_numbness
        t.boolean :sx_nausea
        t.boolean :sx_rash
        t.boolean :sx_vomiting
        t.boolean :sx_cough
        t.boolean :sx_night_sweats
        t.boolean :sx_visual_prob_new
        t.boolean :sx_pain_swallowing
        t.boolean :sx_short_breath
        t.string :sx_other
        t.boolean :dx_hiv
        t.boolean :dx_tb_pulm
        t.boolean :dx_pneumonia
        t.boolean :dx_malaria
        t.boolean :dx_uri
        t.boolean :dx_acute_ge
        t.boolean :dx_otitis_media_acute
        t.boolean :dx_otitis_media_chronic
        t.boolean :dx_thrush
        t.boolean :dx_tinea_capitis
        t.boolean :dx_scabies
        t.boolean :dx_parotitis
        t.boolean :dx_dysentery
        t.boolean :scheduled
      end
  end
end
