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
#  ht                      :float
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
end
