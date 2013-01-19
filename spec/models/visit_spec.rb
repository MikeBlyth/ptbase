# == Schema Information
#
# Table name: visits
#
#  id                         :integer          not null, primary key
#  patient_id                 :integer
#  date                       :datetime
#  next_visit                 :datetime
#  dx                         :string(255)
#  dx2                        :string(255)
#  comments                   :string(255)
#  weight                     :float
#  height                     :float
#  head_circ                  :float
#  meds                       :string(255)
#  newdx                      :boolean
#  newpt                      :boolean
#  adm                        :boolean
#  sbp                        :integer
#  dbp                        :integer
#  scheduled                  :boolean
#  provider_id                :integer
#  hiv_stage                  :string(255)
#  arv_status                 :string(255)
#  anti_tb_status             :string(255)
#  reg_zidovudine             :boolean
#  reg_stavudine              :boolean
#  reg_lamivudine             :boolean
#  reg_didanosine             :boolean
#  reg_nevirapine             :boolean
#  reg_efavirenz              :boolean
#  reg_kaletra                :boolean
#  hpi                        :text
#  temperature                :float
#  development                :text
#  assessment                 :text
#  plan                       :text
#  mid_arm_circ               :float
#  resp_rate                  :integer
#  heart_rate                 :integer
#  phys_exam                  :text
#  diet_breast                :boolean
#  diet_breastmilk_substitute :boolean
#  diet_pap                   :boolean
#  diet_solids                :boolean
#  assessment_stable          :boolean
#  assessment_oi              :boolean
#  assessment_drug_toxicity   :boolean
#  assessment_nonadherence    :boolean
#  arv_missed                 :integer
#  arv_missed_week            :integer
#  created_at                 :datetime
#  updated_at                 :datetime
#  arv_regimen                :string(255)
#  symptoms                   :hstore
#  exam                       :hstore
#  diagnoses                  :hstore
#

# == Schema Information
#
# Table name: visits
#
#  id                      :integer          not null, primary key
#  patient_id              :integer
#  date                    :datetime
#  next_visit              :datetime
#  dx                      :string(255)
#  dx2                     :string(255)
#  comments                :string(255)
#  weight                  :float
#  height                  :float
#  head_circ               :float
#  meds                    :string(255)
#  newdx                   :boolean
#  newpt                   :boolean
#  adm                     :boolean
#  sbp                     :integer
#  dbp                     :integer
#  sx_wt_loss              :boolean
#  sx_fever                :boolean
#  sx_headache             :boolean
#  sx_diarrhea             :boolean
#  sx_numbness             :boolean
#  sx_nausea               :boolean
#  sx_rash                 :boolean
#  sx_vomiting             :boolean
#  sx_cough                :boolean
#  sx_night_sweats         :boolean
#  sx_visual_prob_new      :boolean
#  sx_pain_swallowing      :boolean
#  sx_short_breath         :boolean
#  sx_other                :string(255)
#  dx_hiv                  :boolean
#  dx_tb_pulm              :boolean
#  dx_pneumonia            :boolean
#  dx_malaria              :boolean
#  dx_uri                  :boolean
#  dx_acute_ge             :boolean
#  dx_otitis_media_acute   :boolean
#  dx_otitis_media_chronic :boolean
#  dx_thrush               :boolean
#  dx_tinea_capitis        :boolean
#  dx_scabies              :boolean
#  dx_parotitis            :boolean
#  dx_dysentery            :boolean
#  scheduled               :boolean
#  provider_id             :integer
#  hiv_stage               :string(255)
#  arv_status              :string(255)
#  anti_tb_status          :string(255)
#
require "spec_helper"

describe Visit do
  let(:visit) {FactoryGirl.build(:visit)}

  describe "Validates record" do

    it "with all required data is valid" do
      visit.should be_valid
    end

    it { should validate_presence_of(:date)}

    it { should validate_presence_of(:patient_id)}

    it 'marks future date invalid' do
      visit.date = Date.tomorrow.to_datetime
      visit.should_not be_valid
      visit.errors[:date].should include "cannot be in the future"
    end
  end

  describe 'weight' do
    it 'rejects weight > 300 kg' do
      visit.weight = 310
      visit.should_not be_valid
      visit.errors[:weight].should_not be_blank
    end
  end

  describe 'ARV regimen (arv_reg_str)' do

    it 'generates abbreviated string from checked ARV columns' do
      visit.reg_zidovudine = true
      visit.reg_lamivudine = true
      visit.reg_kaletra = true
      visit.arv_reg_str.should eq 'ZDV, 3TC, kaletra'
    end

    it 'returns nil if no ARV columns checked' do
      visit.arv_reg_str.should be_nil
    end
  end

  describe 'Filtering table by status' do
    before(:each) do
      @patient = FactoryGirl.create(:patient)
      @starting = FactoryGirl.create(:visit, arv_status: 'B', patient: @patient)
      @continuing = FactoryGirl.create(:visit, arv_status: 'C', patient: @patient)
      @stopping = FactoryGirl.create(:visit, arv_status: 'X', patient: @patient)
    end

    it 'finds patients who are starting ARVs' do
      Visit.starting_arv.should eq [@starting]
    end

    it 'finds patients who are continuing ARVs' do
      Visit.continuing_arv.should eq [@continuing]
    end
    it 'finds patients who are starting ARVs' do
      Visit.stopping_arv.should eq [@stopping]
    end
  end
end
