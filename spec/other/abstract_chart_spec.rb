require 'abstract_chart'
include AbstractChart

describe AbstractChart do
  let(:height_data) {[[0, 50],[1, 80], [0.5, 65]] }
  let(:weight_data) {[[0, 3],[1, 10], [2, 12]] }
  let(:weight_data_hash) {[{:age=>0, :weight=>3}, {:age=>1, :weight=>10},{:age=>2, :weight=>12}]}
  let(:height_data_hash) {[{:age=>0, :height=>50}, {:age=>0.5, :height=>65}, {:age=>1, :height=>80}]}
  let(:ht_wt_data_hash) {[{:age=>0, :height=>50, :weight=>3}, {:age=>0.5, :height=>65},
                          {:age=>1, :height=>80, :weight=>10}, {:age=>2, :weight=>12}]}
  let(:age_axis) {Axis.new({orientation: :x, name: :age, min: 0, max: 18, label: "Age", title: {text: 'Age'}})}
  let(:weight_axis) {Axis.new({orientation: :y, name: :weight, min: 0, max: 100, label: "Wt", title: {text: 'Wt'}})}
  let(:height_axis) {Axis.new({orientation: :y, name: :height, min: 40, max: 180, label: "Ht", title: {text: 'Ht'}})}
  let(:weight_series) {DataSeries.new({x_name: :age, y_axis: :weight, data: weight_data})}
  let(:height_series) {DataSeries.new({x_name: :age, y_axis: :height, data: height_data})}
  describe 'Chart' do

    it 'initializes from hash' do
      c = Chart.new title: 'Title'
      c[:title].should eq 'Title'
    end

    it 'renders axes to HighChart' do
      c = Chart.new
      c.add_axis age_axis
      c.add_axis weight_axis
      c.add_axis height_axis
      rendered = c.render_axes_to_highchart
      rendered.should == {xAxis: [age_axis], yAxis: [weight_axis, height_axis]}.to_json
    end

    it 'finds index of a y_axis' do
      c = Chart.new
      c.add_axis age_axis
      c.add_axis weight_axis
      c.add_axis height_axis
      c.y_axis_index({y_axis: :height}).should == {:yAxis => 1}
    end

    it 'renders series to HighChart' do
      c = Chart.new
      c.add_axis age_axis
      c.add_axis weight_axis
      c.add_axis height_axis
      c.add_series weight_series
      c.add_series height_series
      rendered = c.render_series_to_highchart
      rendered.should == {series: [weight_series.to_highchart.merge({yAxis: 0}),
                                   height_series.to_highchart.merge({yAxis: 1})]}.to_json
    end

    it 'renders entire chart as JS for HighChart' do
      c = Chart.new title: 'Growth Chart'
      c.add_axis age_axis
      c.add_axis weight_axis
      c.add_axis height_axis
      c.add_series weight_series
      c.add_series height_series
      rendered = c.render_to_highchart
      puts "rendered = #{rendered}"
      rendered.should == "$(document).ready(function() {\n  chart1 = new Highcharts.Chart({\n     chart: {\n        renderTo: 'chart',\n        type: 'line'\n     },\n     title: {\n        text: 'Growth Chart'\n     },\n     {\"xAxis\":[{\"orientation\":\"x\",\"name\":\"age\",\"min\":0,\"max\":18,\"label\":\"Age\",\"title\":{\"text\":\"Age\"}}],\"yAxis\":[{\"orientation\":\"y\",\"name\":\"weight\",\"min\":0,\"max\":100,\"label\":\"Wt\",\"title\":{\"text\":\"Wt\"}},{\"orientation\":\"y\",\"name\":\"height\",\"min\":40,\"max\":180,\"label\":\"Ht\",\"title\":{\"text\":\"Ht\"}}]},\n     {\"series\":[{\"y_axis\":\"weight\",\"data\":[[0,3],[1,10],[2,12]],\"name\":\"Weight\",\"yAxis\":0},{\"y_axis\":\"height\",\"data\":[[0,50],[1,80],[0.5,65]],\"name\":\"Height\",\"yAxis\":1}]}\n  })\n})\n"
    end
  end

  describe 'Axis' do
    let(:axis_params) {{:label => 'Weight', :min => 0, :max => 30, :color => :red }}

    it 'initializes from hash' do
      a = Axis.new({label: 'Weight', min: 0, max: 30, color: :red })
      a.should == {label: 'Weight', min: 0, max: 30, color: :red, orientation: :y }
    end

    it 'renders all attributes by default' do
      a = Axis.new(axis_params)
      a.render.should == axis_params
    end

    it 'renders to Highchart format' do
      a = Axis.new(axis_params)
      a.render_highchart.should == axis_params.merge({orientation: :y, title: {text: 'Weight'}})
    end
  end

  describe 'DataArray' do
    let(:data) {DataArray.new(:x_name => :age, :y_axis => :weight, :data => weight_data) }

    it 'initializes from hash' do
      data.x_name.should == :age
      data.y_axis.should == :weight
      data.should == weight_data
    end

    it 'converts to simple hash' do
      data.to_simple_hash.should == {:weight => {0=>3, 1=>10, 2=>12}}
    end

    it 'converts to labeled hash' do
      data.to_labeled_hash.should == weight_data_hash
    end

  end

  describe 'DataSeries' do

    it 'initializes from hash' do
      series = DataSeries.new x_name: 'x-name', y_axis: 'y-name'
      series[:x_name].should eq 'x-name'
      series[:y_axis].should eq 'y-name'
      series[:data].should == []
    end

    it 'adds data from x/y array' do
      series = DataSeries.new x_name: 'x-name', y_axis: 'y-name'
      new_data = [[0,0],[1,1]]
      series.add_data(new_data)
      series[:data].should eq new_data
    end

    it 'adds data from array of hashes' do
      series = DataSeries.new x_name: :age, y_axis: :weight
      series.add_data(weight_data_hash)
      series[:data].should eq weight_data
    end

    it 'adds xy data on initialization' do
      new_data = [[0,0],[1,1]]
      series = DataSeries.new x_name: :x_name, y_axis: :y_axis, data: new_data
      series[:data].should eq [[0,0],[1,1]]
    end

    it 'adds xy data on initialization' do
      new_data = [{age: 0, weight: 3}, {age: 1, weight: 10}]
      series = DataSeries.new x_name: :age, y_axis: :weight, data: new_data
      series[:data].should eq [[0,3],[1,10]]
    end

    it 'generates array of hashes {x_name: x, y_axis: y}' do
      series = DataSeries.new x_name: 'x-name', y_axis: 'y-name', data: [[0,2],[1,4]]
      series.to_hash_array.should == [{'x-name' => 0, 'y-name' => 2}, {'x-name' => 1, 'y-name' => 4}]
    end

    it 'merges collection of series into hash array' do
#      series_1 = DataSeries.new x_name: :age, y_axis: :height, data: height_data
#      series_2 = DataSeries.new x_name: :age, y_axis: :weight, data: weight_data
      merged = DataSeries.merge_as_hash [height_series, weight_series]
      merged.should == ht_wt_data_hash
    end

    it 'generates data series for highchart' do
      series = height_series
      series.to_highchart(color: :red).should == {:name => 'Height', :data =>  height_data,
                                                  :y_axis => :height, :color => :red}
    end
  end

  describe 'processing' do

  end
end