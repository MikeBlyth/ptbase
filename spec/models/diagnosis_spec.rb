# == Schema Information
#
# Table name: diagnoses
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  label        :string(255)
#  synonyms     :string(255)
#  comments     :string(255)
#  show_visits  :boolean
#  sort_order   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  with_comment :boolean
#

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
