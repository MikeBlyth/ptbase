require "spec_helper"

describe DrugPrep do

  describe "Validates record" do
    let(:drug_prep) {FactoryGirl.build(:drug_prep)}

    it "with all required data is valid" do
      drug_prep.should be_valid
    end

    it { should validate_presence_of(:form)}

    it { should validate_presence_of(:drug_id)}
  end
end
