require "spec_helper"

describe PrescriptionItem do

  describe "Validates record" do
    let(:prescription_item) {FactoryGirl.build(:prescription_item)}

    it "with all required data is valid" do
      prescription_item.should be_valid
    end

    it { should validate_presence_of(:drug)}

    it { should validate_presence_of(:prescription_id)}

  end

end
