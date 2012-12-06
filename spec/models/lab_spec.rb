# == Schema Information
#
# Table name: labs
#
#  id            :integer          not null, primary key
#  patient_id    :integer
#  categories    :string(255)
#  date          :datetime
#  wbc           :integer
#  neut          :integer
#  lymph         :integer
#  bands         :integer
#  eos           :integer
#  hct           :integer
#  retic         :float
#  esr           :integer
#  platelets     :integer
#  malaria_smear :string(255)
#  csf_rbc       :integer
#  csf_wbc       :integer
#  csf_lymph     :integer
#  csf_neut      :integer
#  csf_protein   :integer
#  csf_glucose   :string(255)
#  csf_culture   :string(255)
#  blood_glucose :integer
#  urinalysis    :string(255)
#  bili          :float
#  hiv_screen    :string(255)
#  hiv_antigen   :string(255)
#  wb            :string(255)
#  mantoux       :string(255)
#  hb_elect      :string(255)
#  other         :string(255)
#  creat         :float
#  cd4           :integer
#  cd4pct        :integer
#  amylase       :integer
#  sgpt          :integer
#  sgot          :integer
#  hbsag         :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  provider_id   :integer
#

require "spec_helper"

describe Lab do

  describe "Validates record" do
    let(:lab) {FactoryGirl.build(:lab)}

    it "with all required data is valid" do
      lab.should be_valid
    end

    it { should validate_presence_of(:date)}

    it { should validate_presence_of(:patient_id)}

    it 'marks future date invalid' do
      lab.date = Date.tomorrow.to_datetime
      lab.should_not be_valid
      lab.errors[:date].should include "cannot be in the future"
    end
  end

end
