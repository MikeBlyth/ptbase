# == Schema Information
#
# Table name: lab_services
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  abbrev       :string(255)
#  unit         :string(255)
#  normal_range :string(255)
#  lab_group_id :integer
#  cost         :float
#  comments     :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require "spec_helper"

describe LabService do
  describe 'validation' do
    it { should validate_presence_of(:name)}
    it { should validate_presence_of(:abbrev)}
  end

end


