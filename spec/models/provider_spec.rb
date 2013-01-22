# == Schema Information
#
# Table name: providers
#
#  id          :integer          not null, primary key
#  last_name   :string(255)
#  first_name  :string(255)
#  middle_name :string(255)
#  ident       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require "spec_helper"

describe Provider do

  describe "Validates record" do
    let(:provider) {FactoryGirl.build(:provider)}

    it "with all required data is valid" do
      provider.should be_valid
    end

    it { should validate_presence_of(:first_name)}
    it { should validate_presence_of(:last_name)}

  end

end
