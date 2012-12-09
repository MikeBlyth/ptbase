# == Schema Information
#
# Table name: patients
#
#  id               :integer          not null, primary key
#  first_name       :string(255)
#  last_name        :string(255)
#  other_names      :string(255)
#  birth_date       :datetime
#  death_date       :date
#  birth_date_exact :boolean
#  ident            :string(255)
#  sex              :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require "spec_helper"

describe Patient do

  describe "Validates record" do
    let(:patient) {FactoryGirl.build(:patient)}

    it "with all required data is valid" do
      patient.should be_valid
    end

    it { should validate_presence_of(:last_name)}

    it { should validate_presence_of(:ident)}

    it { should validate_uniqueness_of(:ident)}

    it { should validate_presence_of(:birth_date)}

    it 'marks future birth date invalid' do
      patient.birth_date = Date.tomorrow.to_datetime
      patient.should_not be_valid
      patient.errors[:birth_date].should include "cannot be in the future"
    end
  end

  describe 'compose name' do
    let(:patient){Patient.new(last_name: 'Jones', first_name: 'Bernard', ident: 'XYZ')}

    it 'uses first and last name' do
      patient.name.should eq 'Bernard Jones'
    end

    it 'uses first and last name with middle initial' do
      patient.other_names = 'Artexerxes'
      patient.name.should eq 'Bernard A. Jones'
    end

    it 'name_id gives name + ident' do
      name_id = patient.name_id
      name_id.should match /Jones/
      name_id.should match Regexp.new(patient.ident)
    end

    it 'name_last_first works' do
      patient.name_last_first.should eq 'Jones, Bernard'
    end

    it 'name_last_first_id gives name + ident' do
      name_id = patient.name_last_first_id
      name_id.should match /Jones, Bernard/
      name_id.should match Regexp.new(patient.ident)
    end

  end

  # ToDo: Belongs in Prescriptions?
  describe 'Current drugs' do
    let(:patient) {FactoryGirl.create(:patient_with_health_data)}
    let(:prescription) {FactoryGirl.create(:prescription, :confirmed, patient: patient, date: Date.yesterday)}
    let(:current_item) {FactoryGirl.create(:prescription_item, duration: 100, prescription: prescription)}
    let(:non_current_item) {FactoryGirl.create(:prescription_item, duration: 0, prescription: prescription)}

    it 'includes valid item' do
      current_item
      patient.current_drugs.keys.should eq [current_item.drug]
    end

    it 'does not include item no longer being taken' do
      non_current_item
      patient.current_drugs.should be_empty
    end

    it 'does not include void item' do
      current_item
      prescription.update_attributes(:void => true)
      patient.current_drugs.should be_empty
    end

    it 'does not include unconfirmed item' do
      current_item
      prescription.update_attributes(:confirmed => false)
      patient.current_drugs.should be_empty
    end

  end

  # ToDo: Move elsewhere
  describe 'get_last(table, column)' do
    before(:each) do
      @patient = FactoryGirl.create(:patient)
      # Make an Immunization record for each of last three days
      [1,2,3].each {|n| FactoryGirl.create(:immunization, patient: @patient, date: Date.today-n.days,
        bcg: n)}
    end

    it 'gets value of column in most recent record of table' do
      @patient.get_last(Immunization, :bcg)[:value].should eq '1'
    end

    it 'ignores records where column value is nil' do
      Immunization.where("bcg = '1' ").first.update_attributes(bcg: nil)
      @patient.get_last(Immunization, :bcg)[:value].should eq '2'
    end
  end

  # ToDo: Move elsewhere
  describe 'get_latest_parameters()' do
    before(:each) do
      @recent = Date.today
      @old = Date.today - 6.months
      @patient = FactoryGirl.create(:patient)
      FactoryGirl.create(:health_data, patient: @patient)
      @recent_labs = FactoryGirl.create(:lab, :lo_cd4, :anemic, patient: @patient, date: @recent)
      @old_labs = FactoryGirl.create(:lab, :hi_cd4, patient: @patient, date: @old)
      @recent_visit = FactoryGirl.create(:visit, date: @old, patient: @patient,
                                         height: 120, weight: 30, meds: "Meds recent", hiv_stage: 3)
      @old_visit = FactoryGirl.create(:visit, date: @old, patient: @patient,
                                      height: 119, weight: 35, meds: "Meds old", hiv_stage: 1 )
    end

    it 'finds new values when all are present' do
      latest = @patient.get_latest_parameters
      [:weight, :height, :meds,:hiv_stage].each do |param|
        latest[param][:value].to_s.should eq @recent_visit.send(param).to_s
      end
      [:cd4, :cd4pct, :hct].each do |param|
        latest[param][:value].to_s.should eq @recent_labs.send(param).to_s
      end
    end
  end
end
