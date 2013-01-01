require 'growth_chart'

describe GrowthChart do
  before(:each) do
    @patient = FactoryGirl.create(:patient, birth_date: 1.year.ago)
    @visit_1 = FactoryGirl.create(:visit, date: 1.year.ago, patient: @patient, weight: 3, height: 54)
    @visit_2 = FactoryGirl.create(:visit, date: 6.months.ago, patient: @patient, weight: 8, height: 74)
    @lab_1 = FactoryGirl.create(:lab, date: 6.months.ago, patient: @patient, cd4: 1000, cd4pct: 30)
    @lab_1 = FactoryGirl.create(:lab, date: 1.day.ago, patient: @patient, cd4: 300, cd4pct: 15)
  end

  describe 'initialization' do
    it 'initializes from hash' do
      g = GrowthChart.new(@patient)
      g[:title].should match @patient.name
binding.pry
    end
  end
end