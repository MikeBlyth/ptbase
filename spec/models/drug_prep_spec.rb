# == Schema Information
#
# Table name: drug_preps
#
#  id         :integer          not null, primary key
#  drug_id    :integer
#  form       :string(255)
#  strength   :string(255)
#  mult       :float
#  quantity   :string(255)
#  buy_price  :float
#  stock      :float
#  synonyms   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

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
