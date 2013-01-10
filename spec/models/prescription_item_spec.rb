# == Schema Information
#
# Table name: prescription_items
#
#  id                 :integer          not null, primary key
#  drug               :string(255)
#  prescription_id    :integer
#  dose               :string(255)
#  unit               :string(255)
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
  let(:prescription_item) {FactoryGirl.build(:prescription_item)}

  describe "Validates record" do

    it "with all required data is valid" do
      prescription_item.should be_valid
    end

    it { should validate_presence_of(:drug)}

    it { should validate_presence_of(:interval)}

    it { should validate_presence_of(:duration)}

    it 'accepts valid dosing interval' do
      [0,1,2,3,4,6,8,12,18,24,36,48].each do |interval|
        prescription_item.interval = interval
        prescription_item.should be_valid
      end
    end

    it 'rejects invalid dosing interval' do
      [5,7,9].each do |interval|
        prescription_item.interval = interval
        prescription_item.should_not be_valid
      end
    end

  end

  describe 'current marks an item that should still be taken' do
    before(:each) do
      prescription_item.prescription.date = Date.today - 1.week
    end
    it 'marks as current when today is still within prescribed duration' do
      prescription_item.duration = 10 # days
      prescription_item.should be_current
    end

    it 'marks as non-current when today is beyond prescribed duration' do
      prescription_item.duration = 5 # days
      prescription_item.should_not be_current
    end

  end
end
