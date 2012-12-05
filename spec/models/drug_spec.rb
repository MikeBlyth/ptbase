require "spec_helper"

describe Drug do

  describe "Validates record" do
    let(:drug) {FactoryGirl.build(:drug)}

    it "with all required data is valid" do
      drug.should be_valid
    end

    it { should validate_presence_of(:name)}
    it { should validate_uniqueness_of(:name)}

  end

end
