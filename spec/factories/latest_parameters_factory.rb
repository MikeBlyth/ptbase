require 'latest_parameters'
class LatestParametersFactory < LatestParameters
  silence_warnings do
    DATE_1 = '28 Nov 2010'
    DATE_2 = '6 Jun 2011'
    DATE_3 = '14 Sep 2011'
  end

  def initialize(options={})
    self[:patient] = options[:patient] || Patient.new(
                {id: 88, first_name: "Mohammed", last_name: "Audu", other_names: nil,
                birth_date: "2003-09-15", death_date: nil, birth_date_exact: nil,
                ident: "P002", sex: "M"}
                )
    self[:patient_id] = self[:patient].id
    self[:sex] = self[:patient].sex
    self[:latest_visit] = options[:latest_visit] || Visit.new(
      { patient_id: self[:patient_id], date: DATE_3,
       dx: nil, dx2: nil, 
       comments: nil,
       next_visit: nil,
       scheduled: nil, provider_id: nil,
       weight: nil, height: nil, head_circ: nil,
       sbp: nil, dbp: nil, temperature: nil,
       meds: nil, newdx: nil, newpt: nil, adm: nil,
       hpi: nil, 
       development: nil, 
       assessment: nil, 
       plan: nil,
       sx_wt_loss: nil, sx_fever: nil, sx_headache: nil, sx_diarrhea: nil, sx_numbness: nil, sx_nausea: nil, 
         sx_rash: nil, sx_vomiting: nil, sx_cough: nil, sx_night_sweats: nil, sx_visual_prob_new: nil, 
         sx_pain_swallowing: nil, sx_short_breath: nil, sx_other: nil, 
       dx_hiv: nil, dx_tb_pulm: nil, dx_pneumonia: nil, dx_malaria: nil, dx_uri: nil, dx_acute_ge: nil, 
         dx_otitis_media_acute: nil, dx_otitis_media_chronic: nil, dx_thrush: nil, dx_tinea_capitis: nil, 
         dx_scabies: nil, dx_parotitis: nil, dx_dysentery: nil, 
       hiv_stage: nil, 
       arv_status: nil, 
         reg_zidovudine: nil, reg_stavudine: nil, reg_lamivudine: nil, reg_didanosine: nil, reg_nevirapine: nil, 
         reg_efavirenz: nil, reg_kaletra: nil,
       anti_tb_status: nil
      })
    self[:cd4] = {:label => "Latest CD4", :col => "cd4", :unit => nil}
    self[:cd4pct] = {:label => "Latest CD4%", :col => "cd4pct", :unit => "%"}
    self[:comment_cd4] = {:label => "CD4 comment", :col => "comment_cd4", :unit => nil}
    self[:comment_hct] = {:label => "Hct comment", :col => "comment_hct", :unit => nil}
    self[:hct] = {:label => "Latest hct", :col => "hct", :unit => "%", :value => 34, :date => DATE_2}
    self[:weight] = {:label => "Latest weight", :col => "weight", :unit => " kg", :value => 30.0, :date => DATE_3}
    self[:height] = {:label => "Latest height", :col => "height", :unit => " cm", :value => 120.0, :date => DATE_3}
    self[:meds] = {:label => "Latest meds", :col => "meds", :unit => nil}
    self[:hiv_stage] = {:label => "HIV stage", :col => "hiv_stage", :unit => nil}
    self[:pct_expected_ht] = {:value => 95}
    self[:pct_expected_wt] = {:value => 120}
    self[:pct_expected_wt_for_ht] = {:value => 133}

    [:cd4, :cd4pct, :comment_cd4, :hct, :comment_hct, :weight, :height, :meds, :hiv_stage, :pct_expected_ht,
     :pct_expected_wt, :pct_expected_wt_for_ht ].each {|item| change(item, options[item])}
  end

  # Change a base item in the hash. E.g., change(:cd4, 100) or change(:cd4, 100, Date.today)
  # If item is not found in base, change_visit is called to try to find it in the latest_visit,
  #   e.g. change(:dx, "pneumonia") is forwarded to change_visit
  def change(item, new_value, date=DATE_3)
    return false if item.nil?

    if self[item].nil? # If main hash does not have the item, try with the latest_visit sub-hash
      change_visit(item,new_value)
      return
    end
    self[item][:value] = new_value
    self[item][:date] = date
  end


  # change_visit(:dx_malaria, true) or change_visit(dx_malaria: true, dx_hiv: true, weight: 40)
  def change_visit(item, new_value=nil)
    return if item.nil?
    if item.is_a? Hash
      puts "Changing items #{item}"
      item.each {|k,v| self[:latest_visit].send("#{k.to_s}=", v)}
    else
      self[:latest_visit][item] = new_value
    end
  end



end
