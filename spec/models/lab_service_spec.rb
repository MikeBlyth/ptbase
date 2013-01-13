require "spec_helper"

describe LabService do
  describe 'validation' do
    it { should validate_presence_of(:name)}
    it { should validate_presence_of(:abbrev)}
  end

end


