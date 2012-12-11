# == Schema Information
#
# Table name: immunizations
#
#  id          :integer          not null, primary key
#  bcg         :string(255)
#  opv1        :string(255)
#  opv2        :string(255)
#  opv3        :string(255)
#  opv4        :string(255)
#  dpt1        :string(255)
#  dpt2        :string(255)
#  dpt3        :string(255)
#  dpt4        :string(255)
#  tt1         :string(255)
#  tt2         :string(255)
#  tt3         :string(255)
#  tt4         :string(255)
#  hepb1       :string(255)
#  hepb2       :string(255)
#  hepb3       :string(255)
#  hepb4       :string(255)
#  measles1    :string(255)
#  measles2    :string(255)
#  mmr1        :string(255)
#  mmr2        :string(255)
#  hib1        :string(255)
#  hib2        :string(255)
#  hib3        :string(255)
#  hib4        :string(255)
#  mening      :string(255)
#  pneumo      :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  patient_id  :integer
#  date        :date
#  provider_id :integer
#

require "spec_helper"

describe Immunization do

  describe "Validates record" do
    let(:immunization) {FactoryGirl.build(:immunization)}

    it "with all required data is valid" do
      immunization.should be_valid
    end

    it { should validate_presence_of(:patient_id)}

  end

  describe 'summary' do
    let(:birth_date) {Date.today - 1.year}
    let(:last_dpt) {Date.today - 7.months}
    let(:patient) {FactoryGirl.build_stubbed(:patient, birth_date: birth_date)}
    let(:immunization) {FactoryGirl.build_stubbed(:immunization, patient: patient,
          opv1: birth_date + 4.weeks, opv2: birth_date + 10.weeks,
          dpt1: birth_date + 4.weeks, dpt2: birth_date + 10.weeks, dpt3: last_dpt
          )}

    it 'matches behavior of original app' do
      summary = immunization.summary
#      puts summary
      summary['opv'][:count].should eq 2
      summary['measles'][:count].should eq 0
      summary['measles'][:since].should eq nil
      summary['measles'][:next].should eq "measles: none" # This is the original behavior, but not correct; needs next to be calculated
      summary['mmr'][:next].should eq "mmr: none" # This is the original behavior, but not correct; needs next to be calculated
      summary['hepb'][:next].should eq "hepb: none" # This is the original behavior, but not correct; needs next to be calculated
      summary['mening'][:next_s].should eq "*TODAY*"
      summary['hib'][:next_s].should eq "*TODAY*"
      summary[:age].should be_within(0.01).of(1.0)
      summary[:patient].should eq patient
    end

    it 'notes latest of a given immunization' do
      summary = immunization.summary
      summary['dpt'][:last].should eq last_dpt
      summary['dpt'][:since].should eq (Date.today - last_dpt).to_i
    end

    it 'notes the count of a given immunization' do
      summary = immunization.summary
      summary['dpt'][:count].should eq 3
    end

    it 'gives the date next immunization should be given' do
      summary = immunization.summary
      summary['dpt'][:next].should eq Date.today
      summary['dpt'][:next_s].should eq "*TODAY*"
    end
  end
end
