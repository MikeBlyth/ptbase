require 'growth_chart'
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
    @lab_1 = FactoryGirl.create(:lab, date: 6.months.ago, patient: @patient, cd4: 1000, cd4pct: 30)
    @lab_1 = FactoryGirl.create(:lab, date: 1.day.ago, patient: @patient, cd4: 300, cd4pct: 15)
    @chart = GrowthChart.new(@patient)
  end

  describe 'initialization' do

    it 'initializes from hash' do
      @chart[:title].should match @patient.name
    end
  end

  describe 'creating data series' do

    it 'creates weight series' do
      wt_series = @chart.weight_series
      point_match(wt_series[:data][0], [0,3])
      point_match(wt_series[:data][1], [0.5,8])
      #wt_series.x_axis.should == {"name"=>:age, "units"=>"Years", "label"=>"Age"}
      #wt_series.y_axis.should == {"name"=>:weight, "units"=>"kg", "label"=>"Weight"}
      wt_series[:x_name].should == :age
      wt_series[:y_name].should == :weight
    end

    it 'creates height series' do
      ht_series = @chart.height_series
      point_match(ht_series[:data][0], [0,54])
      point_match(ht_series[:data][1], [0.5,74])
      #ht_series.x_axis.should == {"name"=>:age, "units"=>"Years", "label"=>"Age"}
      #ht_series.y_axis.should == {"name"=>:height, "units"=>"cm", "label"=>"Height"}
      ht_series[:x_name].should == :age
      ht_series[:y_name].should == :height
    end

    it 'creates cd4 series' do
      cd4_series = @chart.cd4_series
      point_match(cd4_series[:data][0], [0.5,1000])
      point_match(cd4_series[:data][1], [1.0,300])
      #cd4_series.x_axis.should == {"name"=>:age, "units"=>"Years", "label"=>"Age"}
      #cd4_series.y_axis.should == {"name"=>:cd4, "units"=>"", "label"=>"CD4"}
      cd4_series[:x_name].should == :age
      cd4_series[:y_name].should == :cd4
    end

    it 'creates cd4pct series' do
      cd4pct_series = @chart.cd4pct_series
      point_match(cd4pct_series[:data][0], [0.5, 30])
      point_match(cd4pct_series[:data][1], [1.0, 15])
      #cd4pct_series.x_axis.should == {"name"=>:age, "units"=>"Years", "label"=>"Age"}
      #cd4pct_series.y_axis.should == {"name"=>:cd4pct, "units"=>"%", "label"=>"CD4%"}
      cd4pct_series[:x_name].should == :age
      cd4pct_series[:y_name].should == :cd4pct
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
      @chart.add_all_series
      @chart.add_std_anthro_series
      @chart.add_series @chart.cd4_moderate_series
      @chart.add_series @chart.cd4_severe_series
      @chart.add_series @chart.cd4pct_severe_series
#puts "Growth chart data = #{@chart[:data]_for_morris }"
      data = @chart.data_for_morris
      data.should include({:age=>1, :weight50=>10.2, :height50=>76.2, :cd4_mod=>1000, :cd4_severe=>750, :cd4pct_severe=>20})
      data.select {|p| p[:weight] == @visit_1.weight and p[:height] == @visit_1.height}.should_not be_empty
    end

  end
end