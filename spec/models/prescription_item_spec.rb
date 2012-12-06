# == Schema Information
#
# Table name: prescription_items
#
#  id                 :integer          not null, primary key
#  drug               :string(255)
#  prescription_id    :integer
#  dose               :float
#  units              :string(255)
#  route              :string(255)
#  interval           :integer
#  use_liquid         :boolean
#  liquid             :integer
#  duration           :integer
#  other_description  :string(255)
#  other_instructions :string(255)
#  filled             :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

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
