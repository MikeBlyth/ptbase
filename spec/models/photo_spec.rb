# == Schema Information
#
# Table name: photos
#
#  id           :integer          not null, primary key
#  patient_id   :integer
#  date         :datetime
#  comments     :string(255)
#  content_type :string(255)
#  name_string  :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require "spec_helper"

describe Photo do

  describe "Validates record" do
    let(:photo) {FactoryGirl.build(:photo)}

    it "with all required data is valid" do
      photo.should be_valid
    end

    it { should validate_presence_of(:date)}

    it { should validate_presence_of(:patient_id)}

    it 'marks future date invalid' do
      photo.date = Date.tomorrow.to_datetime
      photo.should_not be_valid
      photo.errors[:date].should include "cannot be in the future"
    end
  end

end
