# == Schema Information
#
# Table name: immunizations
#
#  id          :integer          not null, primary key
#  patient_id  :integer
#  bcg         :date
#  opv1        :date
#  opv2        :date
#  opv3        :date
#  opv4        :date
#  dpt1        :date
#  dpt2        :date
#  dpt3        :date
#  dpt4        :date
#  tt1         :date
#  tt2         :date
#  tt3         :date
#  tt4         :date
#  hepb1       :date
#  hepb2       :date
#  hepb3       :date
#  hepb4       :date
#  measles1    :date
#  measles2    :date
#  mmr1        :date
#  mmr2        :date
#  hib1        :date
#  hib2        :date
#  hib3        :date
#  hib4        :date
#  mening      :date
#  pneumo      :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
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

  # This is just to test the hib_needed method, not the more general immunization summary.
  # ToDo Need to develop tests for each of the immunization guidelines
  describe 'Hib needed' do
    let(:birth_date) {Date.today - 2.years}
    let(:patient) {FactoryGirl.create(:patient, birth_date: birth_date)}

    before(:each) do
      @immunization = FactoryGirl.create(:immunization, patient: patient,
                                         hib1: nil, hib2: nil, hib3: nil)
      Immunization.stub(:find_or_create_by_patient_id => @immunization)
    end

    it 'is true for 2 year old with no previous Hib immunizations' do
      Immunization.hib_needed(patient).should be_true
    end

    it 'is false for 6 year old with no previous Hib immunizations' do
      patient.birth_date = Date.today - 6.years
      Immunization.hib_needed(patient).should be_false
    end

    it 'is false for 1 year old with recent Hib immunization' do
      patient.birth_date = Date.today - 1.years
      @immunization.hib1 = Date.yesterday
      Immunization.hib_needed(patient).should be_false
    end


  end
end

