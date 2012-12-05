# == Schema Information
#
# Table name: admissions
#
#  id               :integer          not null, primary key
#  patient_id       :integer
#  bed              :string(255)
#  ward             :string(255)
#  diagnosis_1      :string(255)
#  diagnosis_2      :string(255)
#  meds             :string(255)
#  weight_admission :float
#  weight_discharge :float
#  date             :datetime
#  discharge_date   :datetime
#  discharge_status :string(255)
#  comments         :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require "spec_helper"

describe Admission do

  describe "Validates record" do
    let(:admission) {FactoryGirl.build(:admission)}

    it "with all required data is valid" do
      admission.should be_valid
    end

    it { should validate_presence_of(:date)}
    it { should validate_presence_of(:diagnosis_1)}
    it { should validate_presence_of(:patient_id)}

    it 'marks future date invalid' do
      admission.date = Date.tomorrow.to_datetime
      admission.should_not be_valid
      admission.errors[:date].should include "cannot be in the future"
    end

  end

end
