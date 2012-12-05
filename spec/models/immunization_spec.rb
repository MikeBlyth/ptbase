require "spec_helper"

describe Immunization do

  describe "Validates record" do
    let(:immunization) {FactoryGirl.build(:immunization)}

    it "with all required data is valid" do
      immunization.should be_valid
    end

    it { should validate_presence_of(:date)}

    it { should validate_presence_of(:patient_id)}

    it 'marks future date invalid' do
      immunization.date = Date.tomorrow.to_datetime
      immunization.should_not be_valid
      immunization.errors[:date].should include "cannot be in the future"
    end
  end

end
