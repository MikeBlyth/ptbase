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
#  comment_hct   :string(255)
#  comment_cd4   :string(255)
#

require "spec_helper"

describe Lab do
  let(:lab) {FactoryGirl.build(:lab)}

  describe "Validates record" do

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

    describe 'Checks labs for result in valid range' do

      it 'validates when result is in range' do
        lab.hct = 30
        lab.should be_valid
      end

      it 'adds error when result is out range' do
        lab.hct = 110
        lab.should_not be_valid
        lab.errors.messages[:hct][0].should match 'invalid'
      end

      it 'does not add error when result is not present' do
        lab.hct = nil
        lab.should be_valid
      end

    end

  end

  describe 'calculated values' do
    it 'calculates absolute neutrophil count' do
      lab.wbc = 10000
      lab.neut = 25 # percent
      lab.anc.should eq 2500
    end

    it 'calculates total lymphocyte count' do
      lab.wbc = 10000
      lab.lymph = 25 # percent
      lab.tlc.should eq 2500
    end

    it 'calculates absolute eosinophil count' do
      lab.wbc = 10000
      lab.eos = 25 # percent
      lab.aec.should eq 2500
    end


  end

end
