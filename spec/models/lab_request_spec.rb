require "spec_helper"

describe LabRequest do
  describe 'validation' do
    it { should validate_presence_of(:patient_id)}
    it { should validate_presence_of(:provider_id)}

    it 'should set date to today if not specified' do
      r = LabRequest.new
      r.valid?
      r.date.to_date.should == Date.today
    end
  end

end


