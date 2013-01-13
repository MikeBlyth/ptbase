require "spec_helper"

describe LabRequest do
  describe 'validation' do
    it { should validate_presence_of(:patient_id)}
    it { should validate_presence_of(:provider_id)}
  end

end


