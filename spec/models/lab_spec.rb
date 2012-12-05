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
