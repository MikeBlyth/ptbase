# == Schema Information
#
# Table name: patients
#
#  id               :integer          not null, primary key
#  first_name       :string(255)
#  last_name        :string(255)
#  other_names      :string(255)
#  birth_date       :date
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

    it "missing last name should be invalid" do
      patient.last_name = nil
      patient.should_not be_valid
      patient.errors[:last_name].should include "can't be blank"
    end

    it "missing ident should be invalid" do
      patient.ident = nil
      patient.should_not be_valid
      patient.errors[:ident].should include "can't be blank"
    end

    it "missing birth date should be invalid" do
      patient.birth_date = nil
      patient.should_not be_valid
      patient.errors[:birth_date].should include "can't be blank"
    end

    it "duplicate ident should be invalid"   do
      patient_1 = FactoryGirl.create(:patient)
      patient.ident = patient_1.ident
      patient.should_not be_valid
      patient.errors[:ident].should include "has already been taken"
    end

    it 'marks future birth date invalid' do
      patient.birth_date = Date.tomorrow.to_datetime
      patient.should_not be_valid
      patient.errors[:birth_date].should include "cannot be in the future"
    end
  end

  describe 'compose name' do
    let(:patient){Patient.new(last_name: 'Jones', first_name: 'Bernard')}

    it 'uses first and last name' do
      patient.name.should eq 'Bernard Jones'
    end

    it 'uses first and last name with middle initial' do
      patient.other_names = 'Artexerxes'
      patient.name.should eq 'Bernard A. Jones'
    end

  end
end
