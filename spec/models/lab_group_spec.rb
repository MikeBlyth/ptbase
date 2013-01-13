require "spec_helper"

describe LabGroup do
  describe 'validation' do
    it { should validate_presence_of(:name)}
    it { should validate_presence_of(:abbrev)}
  end

end


