# == Schema Information
#
# Table name: problems
#
#  id          :integer          not null, primary key
#  description :string(255)
#  date        :datetime
#  resolved    :datetime
#  patient_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require "spec_helper"

describe Problem do

  describe "Validates record" do
    let(:problem) {FactoryGirl.build(:problem)}

    it "with all required data is valid" do
      problem.should be_valid
    end

    it { should validate_presence_of(:date)}

    it { should validate_presence_of(:patient_id)}

    it { should validate_presence_of(:description)}

    it 'marks future date invalid' do
      problem.date = Date.tomorrow.to_datetime
      problem.should_not be_valid
      problem.errors[:date].should include "cannot be in the future"
    end

    it 'marks future resolution date invalid' do
      problem.resolved = Date.tomorrow.to_datetime
      problem.should_not be_valid
      problem.errors[:resolved].should include "cannot be in the future"
    end

  end

end
