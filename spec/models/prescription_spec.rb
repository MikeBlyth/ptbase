# == Schema Information
#
# Table name: prescriptions
#
#  id            :integer          not null, primary key
#  patient_id    :integer
#  prescriber_id :integer
#  date          :datetime
#  filled        :boolean
#  confirmed     :boolean
#  voided        :boolean
#  weight        :float
#  height        :float
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require "spec_helper"

describe Prescription do

  describe "Validates record" do
    let(:prescription) {FactoryGirl.build(:prescription)}

    it "with all required data is valid" do
      prescription.should be_valid
    end

    it { should validate_presence_of(:date)}

    it { should validate_presence_of(:patient_id)}
    it { should validate_presence_of(:prescriber_id)}

    it 'marks future date invalid' do
      prescription.date = Date.tomorrow.to_datetime
      prescription.should_not be_valid
      prescription.errors[:date].should include "cannot be in the future"
    end
  end

end
