# == Schema Information
#
# Table name: lab_groups
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  abbrev     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require "spec_helper"

describe LabGroup do
  describe 'validation' do
    it { should validate_presence_of(:name)}
    it { should validate_presence_of(:abbrev)}
  end

end


