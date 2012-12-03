require "rspec"
require "birth_date.rb"

describe "Birth date human_age formats as nice string" do

  it "formats ok" do
    now = DateTime.now
    (now - 2.hours).age_human.should eq '2 hours'
    (now - 28.hours).age_human.should eq '28 hours'
    (now - 4.days).age_human.should eq '4 days'
    (now - 6.weeks).age_human.should eq '6 weeks'
    (now - 3.months).age_human.should match '3 months'
    (now - 13.months).age_human.should eq '13 months (1.1 years)'
    (now - 37.months).age_human.should eq '3.1 years'
    (now - 10.years).age_human.should eq '10 years'
  end

end