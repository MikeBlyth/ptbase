require 'abstract_chart'
include AbstractChart

describe AbstractChart do
  let(:height_data) {[[0, 50],[1, 80], [0.5, 65]] }
  let(:weight_data) {[[0, 3],[1, 10], [2, 12]] }
  let(:weight_data_hash) {[{:age=>0, :weight=>3}, {:age=>1, :weight=>10},{:age=>2, :weight=>12}]}
  let(:height_data_hash) {[{:age=>0, :height=>50}, {:age=>0.5, :height=>65}, {:age=>1, :height=>80}]}
  let(:ht_wt_data_hash) {[{:age=>0, :height=>50, :weight=>3}, {:age=>0.5, :height=>65},
                          {:age=>1, :height=>80, :weight=>10}, {:age=>2, :weight=>12}]}

  describe 'Chart' do

    it 'initializes from hash' do
      c = Chart.new title: 'Title'
      c[:title].should eq 'Title'
    end

    it 'renders axes to HighChart' do
      c = Chart.new
      ax = Axis.new({orientation: :x, name: :age, min: 0, max: 18, label: "Age", title: {text: 'Age'}})
      ay_1 = Axis.new({orientation: :y, name: :weight, min: 0, max: 100, label: "Wt", title: {text: 'Wt'}})
      ay_2 = Axis.new({orientation: :y, name: :height, min: 40, max: 180, label: "Ht", title: {text: 'Ht'}})
      c.add_axis ax
      c.add_axis ay_1
      c.add_axis ay_2
      rendered = c.render_axes_to_highchart
      rendered.should == {xAxis: [ax], yAxis: [ay_1, ay_2]}.to_json
    end

    it 'finds index of a y_axis' do
      c = Chart.new
      c.add_axis Axis.new({orientation: :x, name: :age, min: 0, max: 18, label: "Age", title: {text: 'Age'}})
      c.add_axis  Axis.new({orientation: :y, name: :weight, min: 0, max: 100, label: "Wt", title: {text: 'Wt'}})
      c.add_axis Axis.new({orientation: :y, name: :height, min: 40, max: 180, label: "Ht", title: {text: 'Ht'}})
      c.y_axis_index({y_name: :height}).should == {:yAxis => 1}
    end

    it 'renders series to HighChart' do
      c = Chart.new
      c.add_axis Axis.new({orientation: :x, name: :age, min: 0, max: 18, label: "Age", title: {text: 'Age'}})
      c.add_axis  Axis.new({orientation: :y, name: :weight, min: 0, max: 100, label: "Wt", title: {text: 'Wt'}})
      c.add_axis Axis.new({orientation: :y, name: :height, min: 40, max: 180, label: "Ht", title: {text: 'Ht'}})
      s_1 = DataSeries.new({name: :weight, x_name: :age, y_name: :weight, data: [[0,3], [1,10]]})
      s_2 = DataSeries.new({name: :height, x_name: :age, y_name: :height, data: [[0,52], [1,80]]})
      c.add_series s_1
      c.add_series s_2
      rendered = c.render_series_to_highchart
      rendered.should == {series: [s_1.to_highchart.merge({yAxis: 0}), s_2.to_highchart.merge({yAxis: 1})]}.to_json
    end

    it 'renders entire chart as JS for HighChart' do
      c = Chart.new title: 'Growth Chart'
      c.add_axis Axis.new({orientation: :x, name: :age, min: 0, max: 18, label: "Age", title: {text: 'Age'}})
      c.add_axis  Axis.new({orientation: :y, name: :weight, min: 0, max: 100, label: "Wt", title: {text: 'Wt'}})
      c.add_axis Axis.new({orientation: :y, name: :height, min: 40, max: 180, label: "Ht", title: {text: 'Ht'}})
      s_1 = DataSeries.new({name: :weight, x_name: :age, y_name: :weight, data: [[0,3], [1,10]]})
      s_2 = DataSeries.new({name: :height, x_name: :age, y_name: :height, data: [[0,52], [1,80]]})
      c.add_series s_1
      c.add_series s_2
      rendered = c.render_to_highchart
      rendered.should == "$(document).ready(function() {\n  chart1 = new Highcharts.Chart({\n     chart: {\n        renderTo: 'chart',\n        type: 'line'\n     },\n     title: {\n        text: 'Growth Chart'\n     },\n     {\"xAxis\":[{\"orientation\":\"x\",\"name\":\"age\",\"min\":0,\"max\":18,\"label\":\"Age\",\"title\":{\"text\":\"Age\"}}],\"yAxis\":[{\"orientation\":\"y\",\"name\":\"weight\",\"min\":0,\"max\":100,\"label\":\"Wt\",\"title\":{\"text\":\"Wt\"}},{\"orientation\":\"y\",\"name\":\"height\",\"min\":40,\"max\":180,\"label\":\"Ht\",\"title\":{\"text\":\"Ht\"}}]},\n     {\"series\":[{\"name\":null,\"data\":[[0,3],[1,10]],\"yAxis\":0},{\"name\":null,\"data\":[[0,52],[1,80]],\"yAxis\":1}]}\n  })\n})\n"
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
    let(:data) {DataArray.new(:x_name => :age, :y_name => :weight, :data => weight_data) }

    it 'initializes from hash' do
      data.x_name.should == :age
      data.y_name.should == :weight
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
      series = DataSeries.new x_name: 'x-name', y_name: 'y-name'
      series[:x_name].should eq 'x-name'
      series[:y_name].should eq 'y-name'
      series[:data].should == []
    end

    it 'adds data from x/y array' do
      series = DataSeries.new x_name: 'x-name', y_name: 'y-name'
      new_data = [[0,0],[1,1]]
      series.add_data(new_data)
      series[:data].should eq new_data
    end

    it 'adds data from array of hashes' do
      series = DataSeries.new x_name: :age, y_name: :weight
      series.add_data(weight_data_hash)
      series[:data].should eq weight_data
    end

    it 'adds xy data on initialization' do
      new_data = [[0,0],[1,1]]
      series = DataSeries.new x_name: :x_name, y_name: :y_name, data: new_data
      series[:data].should eq [[0,0],[1,1]]
    end

    it 'adds xy data on initialization' do
      new_data = [{age: 0, weight: 3}, {age: 1, weight: 10}]
      series = DataSeries.new x_name: :age, y_name: :weight, data: new_data
      series[:data].should eq [[0,3],[1,10]]
    end

    #it 'initializes axes' do
    #  series = DataSeries.new(x_name: :age, y_name: :weight, x_label: "Age", y_label: "Weight",
    #                          x_units: "Years", y_units: "kg" )
    #  series[:x_axis].should == {:name => :age, :units => "Years", :label => "Age"}
    #  series[:y_axis].should == {:name  => :weight, :units =>  "kg", :label =>  "Weight"}
    #end
    #
    #it 'initializes axes with default axis labels' do
    #  series = DataSeries.new(x_name: :age, y_name: :body_weight, x_units: "Years", y_units: "kg" )
    #  series[:x_axis].should == {:name => :age, :units => "Years", :label => "Age"}
    #  series[:y_axis].should == {:name  => :body_weight, :units =>  "kg", :label =>  "Body weight"}
    #end

    it 'generates array of hashes {x_name: x, y_name: y}' do
      series = DataSeries.new x_name: 'x-name', y_name: 'y-name', data: [[0,2],[1,4]]
      series.to_hash_array.should == [{'x-name' => 0, 'y-name' => 2}, {'x-name' => 1, 'y-name' => 4}]
    end

    it 'merges collection of series into hash array' do
      series_1 = DataSeries.new x_name: :age, y_name: :height, data: height_data
      series_2 = DataSeries.new x_name: :age, y_name: :weight, data: weight_data
      merged = DataSeries.merge_as_hash [series_1, series_2]
      merged.should == ht_wt_data_hash
    end

    it 'generates data series for highchart' do
      series = DataSeries.new x_name: :age, y_name: :height, data: height_data, x_label: 'Age'
      series.to_highchart(color: :red).should == {:name => 'Age', :data =>  height_data, :color => :red}
    end
  end

  describe 'processing' do

  end
end