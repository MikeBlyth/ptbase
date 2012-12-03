require "rspec"

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