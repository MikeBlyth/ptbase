require 'abstract_chart'
include AbstractChart

describe AbstractChart do
  let(:height_data) {[[0, 50],[1, 80], [0.5, 65]] }
  let(:weight_data_hash) {[{'age'=>0, 'weight'=>3}, {'age'=>1, 'weight'=>10},{'age'=>2, 'weight'=>12}]}
  let(:weight_data) {[[0, 3],[1, 10], [2, 12]] }

  describe 'Chart' do

    it 'initializes from hash' do
      c = Chart.new title: 'Test title'
      c[:title].should eq 'Test title'
    end
  end

  describe 'Axis' do

    it 'initializes from hash' do
      a = Axis.new title: 'Test title'
      a[:title].should eq 'Test title'
    end
  end

  describe 'DataArray' do
    let(:data) {DataArray.new(x_name: 'age', y_name: 'weight', data: weight_data) }

    it 'initializes from hash' do
      data.x_name.should == 'age'
      data.y_name.should == 'weight'
      data.should eq weight_data
    end

    it 'converts to simple hash' do
      data.to_simple_hash.should == {'weight' => {0=>3, 1=>10, 2=>12}}
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
      series[:data].should be_nil
    end

    it 'adds data from x/y array' do
      series = DataSeries.new x_name: 'x-name', y_name: 'y-name'
      new_data = [[0,0],[1,1]]
      series.add_data(new_data)
      series[:data].should eq new_data
    end

    #it 'adds data from array of hashes' do
    #  series = DataSeries.new x_name: :x_name, y_name: :y_name
    #  new_data = [{x_name: 0, y_name: 0, something: 1}, {x_name: 1, y_name: 1, something: 2} ]
    #  series.add_data(new_data)
    #  series[:data]should eq [[0,0],[1,1]]
    #end

    it 'adds data on initialization' do
      new_data = [[0,0],[1,1]]
      series = DataSeries.new x_name: :x_name, y_name: :y_name, data: new_data
      series[:data].should eq [[0,0],[1,1]]
    end

    #it 'initializes axes' do
    #  series = DataSeries.new(x_name: :age, y_name: :weight, x_label: "Age", y_label: "Weight",
    #                          x_units: "Years", y_units: "kg" )
    #  series[:x_axis].should == {'name' => :age, 'units' => "Years", 'label' => "Age"}
    #  series[:y_axis].should == {'name'  => :weight, 'units' =>  "kg", 'label' =>  "Weight"}
    #end
    #
    #it 'initializes axes with default axis labels' do
    #  series = DataSeries.new(x_name: :age, y_name: :body_weight, x_units: "Years", y_units: "kg" )
    #  series[:x_axis].should == {'name' => :age, 'units' => "Years", 'label' => "Age"}
    #  series[:y_axis].should == {'name'  => :body_weight, 'units' =>  "kg", 'label' =>  "Body weight"}
    #end

    it 'generates array of hashes {x_name: x, y_name: y}' do
      series = DataSeries.new x_name: 'x-name', y_name: 'y-name', data: [[0,2],[1,4]]
      series.to_hash_array.should == [{'x-name' => 0, 'y-name' => 2}, {'x-name' => 1, 'y-name' => 4}]
    end

    it 'merges collection of series into hash array' do
      series_1 = DataSeries.new x_name: 'age', y_name: 'height', data: height_data
      series_2 = DataSeries.new x_name: 'age', y_name: 'weight', data: [[0, 3.0],[1, 10], [0.75, 8]]
      merged = DataSeries.merge_as_hash [series_1, series_2]
      merged.should == [{'age' => 0, 'height' =>50, 'weight' =>3.0}, {'age' =>0.5, 'height' =>65},
                        {'age' =>0.75, 'weight' =>8}, {'age' =>1, 'height' =>80, 'weight' =>10}]
    end

    it 'generates data series for highchart' do
      series = DataSeries.new x_name: 'age', y_name: 'height', data: height_data, x_label: 'Age'
      series.to_highchart(color: 'red').should == {'name' => 'Age', 'data' =>  height_data, 'color' => 'red'}
    end
  end

  describe 'processing' do

  end
end