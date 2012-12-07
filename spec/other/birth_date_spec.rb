require "spec_helper"
require "birth_date.rb"

describe "Added DateTime Methods" do

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

  describe "age on date" do
    let(:datetime) {DateTime.new(2000,1,1)}

    it 'returns duration (age_on_date) in years' do
      datetime.age_on_date_in_years(datetime.to_time+1.year).should be_within(0.01).of(1.0)
    end

    it 'returns duration (age_on_date) human' do
      datetime.age_on_date_human(datetime.to_time+2.years).should eq '2.0 years'
    end
  end

  describe 'works for different classes' do

    it 'works for Time' do
      (Time.now.months_ago 13).age_months.should be_within(0.22).of(13.0)
    end

    it 'works for DateTime' do
      (DateTime.now.months_ago 13).age_months.should be_within(0.22).of(13.0)
    end

    it 'works for Date' do
      (Date.today.years_ago 1).age_years.should be_within(0.1).of(1.0)
    end

    it 'works for ActiveSupport::TimeWithZone' do
      (Date.today.years_ago 1).to_time_in_current_zone.age_years.should be_within(0.1).of(1.0)
    end


  end

end