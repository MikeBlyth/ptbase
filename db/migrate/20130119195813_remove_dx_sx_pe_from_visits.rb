class RemoveDxSxPeFromVisits < ActiveRecord::Migration
  def up
    %w(sx_wt_loss
sx_fever
sx_headache
sx_diarrhea
sx_numbness
sx_nausea
sx_rash
sx_vomiting
sx_cough
sx_night_sweats
sx_visual_prob_new
sx_pain_swallowing
sx_short_breath
sx_ear_pain_disch
sx_other dx_hiv
dx_tb_pulm
dx_pneumonia
dx_malaria
dx_uri
dx_acute_ge
dx_otitis_media_acute
dx_otitis_media_chronic
dx_thrush
dx_tinea_capitis
dx_scabies
dx_parotitis
dx_dysentery pe_scalp_ok
pe_scalp
pe_conjunct_ok
pe_conjunct
pe_eyes_ok
pe_eyes
pe_ears_ok
pe_ears
pe_mouth_ok
pe_mouth
pe_nose_ok
pe_nose
pe_chest_ok
pe_chest
pe_heart_ok
pe_heart
pe_abd_ok
pe_abd
pe_liver_ok
pe_liver
pe_spleen_ok
pe_spleen
pe_skin_ok
pe_skin
pe_lymph_ok
pe_lymph
pe_extr_ok
pe_extr
pe_neuro_ok
pe_neuro
pe_genitalia_ok
pe_genitalia
pe_tanner_ok
pe_tanner
).each {|col| remove_column :visits, col}
  end

  def down
  end
end
