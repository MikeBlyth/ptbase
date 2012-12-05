require "spec_helper"

describe Diagnosis do

  describe "Validates record" do
    let(:diagnosis) {FactoryGirl.build(:diagnosis)}

    it "with all required data is valid" do
      diagnosis.should be_valid
    end

    it { should validate_presence_of(:name)}

  end

end
