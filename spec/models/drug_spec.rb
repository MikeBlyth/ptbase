# == Schema Information
#
# Table name: drugs
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  drug_class    :string(255)
#  drug_subclass :string(255)
#  synonyms      :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

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
