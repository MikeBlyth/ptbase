require 'growth_chart'
require "#{Rails.root}/spec/factories/labs_factory.rb"
include GrowthChartRefLines

# Use to match data points which have age/time/etc. float values for x (first component)
def point_match(point, nominal)
  point[0].should be_within(0.01).of(nominal[0])
  point[1].should eq nominal[1]
end

describe GrowthChart do
  before(:each) do
    @patient = FactoryGirl.create(:patient, birth_date: 1.year.ago)
    @visit_1 = FactoryGirl.create(:visit, date: @patient.birth_date, patient: @patient, weight: 3, height: 54)
    @visit_2 = FactoryGirl.create(:visit, date: @patient.birth_date + 6.months, patient: @patient, weight: 8, height: 74)
    labs_factory = LabsFactory.new(patient: @patient, date: Date.yesterday)
    @labs = labs_factory.add_labs({lab: 'cd4', result: 300},
                                         {lab: 'cd4pct', result: 15})
    labs_factory.date = Date.today - 6.months
    @labs = labs_factory.add_labs({lab: 'cd4', result: 1000},
                                  {lab: 'cd4pct', result: 30})
    @chart = GrowthChart.new(@patient)
  end

  describe 'initialization' do

    it 'initializes from hash' do
      @chart.title.should match @patient.name
    end
  end

  describe 'creating data series' do

    it 'creates weight series' do
      wt_series = @chart.weight_series
      point_match(wt_series[:data][0], [0,3])
      point_match(wt_series[:data][1], [0.5,8])
      wt_series[:x_name].should == :age
      wt_series[:y_axis].should == :weight
    end

    it 'creates height series' do
      ht_series = @chart.height_series
      point_match(ht_series[:data][0], [0,54])
      point_match(ht_series[:data][1], [0.5,74])
      #ht_series.x_axis.should == {"name"=>:age, "units"=>"Years", "label"=>"Age"}
      #ht_series.y_axis.should == {"name"=>:height, "units"=>"cm", "label"=>"Height"}
      ht_series[:x_name].should == :age
      ht_series[:y_axis].should == :height
    end

    it 'creates cd4 series' do
      cd4_series = @chart.cd4_series.sort  # sorting is normally done at rendering time
      puts "labs = #{LabResult.all}"
      point_match(cd4_series[:data][0], [0.5,1000])
      point_match(cd4_series[:data][1], [1.0,300])
      cd4_series[:x_name].should == :age
      cd4_series[:y_axis].should == :cd4
    end

    it 'creates cd4pct series' do
      cd4pct_series = @chart.cd4pct_series.sort
      point_match(cd4pct_series[:data][0], [0.5, 30])
      point_match(cd4pct_series[:data][1], [1.0, 15])
      cd4pct_series[:x_name].should == :age
      cd4pct_series[:y_axis].should == :cd4pct
    end

  end

  describe 'creates reference curves' do

    it 'creates 50% weight reference curve' do
      ref = @chart.weight50_series
      ref[:data].should == PERCENTILE_WT_50_MALE
      @patient.sex = 'F'
      ref = @chart.weight50_series
      ref[:data].should == PERCENTILE_WT_50_FEMALE
    end

    it 'creates 50% height reference curve' do
      ref = @chart.height50_series
      ref[:data].should == PERCENTILE_HT_50_MALE
      @patient.sex = 'F'
      ref = @chart.height50_series
      ref[:data].should == PERCENTILE_HT_50_FEMALE
    end

    it 'creates CD4 moderate reference curve' do
      ref = @chart.cd4_moderate_series
      ref[:data].should == CD4_MODERATE
    end

    it 'creates CD4 severe reference curve' do
      ref = @chart.cd4_severe_series
      ref[:data].should == CD4_SEVERE
    end

    it 'creates CD4% severe reference curve' do
      ref = @chart.cd4pct_severe_series
      ref[:data].should == CD4PCT_SEVERE
    end

    it 'makes data for morris graphing package' do
#puts "Growth chart data = #{@chart[:data]_for_morris }"
      data = @chart.data_for_morris
      data.should include({:age=>1, 'Weight 50%ile'=>10.2, 'Height 50%ile'=>76.2, 'CD4 Moderate'=>1500,
                           'CD4 Severe'=>1500, 'CD4% Severe'=>25})
      data.select {|p| p['Weight (kg)'] == @visit_1.weight and p['Height (cm)'] == @visit_1.height}.should_not be_empty
    end

    it 'makes data for Highchart graphing package' do
      rendered = @chart.render_to_highchart
      puts rendered
    end

  end
end