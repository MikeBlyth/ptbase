require "spec_helper"

describe Provider do

  describe "Validates record" do
    let(:provider) {FactoryGirl.build(:provider)}

    it "with all required data is valid" do
      provider.should be_valid
    end

    it { should validate_presence_of(:first_name)}
    it { should validate_presence_of(:last_name)}

  end

end
