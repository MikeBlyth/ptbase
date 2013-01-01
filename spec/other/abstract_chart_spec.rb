require 'abstract_chart'
include AbstractChart

describe AbstractChart do

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

  describe 'DataSeries' do

    it 'initializes from hash' do
      series = DataSeries.new x_name: 'x-name', y_name: 'y-name'
      series.x_name.should eq 'x-name'
      series.y_name.should eq 'y-name'
      series.data.should eq []
    end

    it 'adds data from x/y array' do
      series = DataSeries.new x_name: 'x-name', y_name: 'y-name'
      new_data = [[0,0],[1,1]]
      series.add_data(new_data)
      series.data.should eq new_data
    end

    it 'adds data from array of hashes' do
      series = DataSeries.new x_name: :x_name, y_name: :y_name
      new_data = [{x_name: 0, y_name: 0, something: 1}, {x_name: 1, y_name: 1, something: 2} ]
      series.add_data(new_data)
      series.data.should eq [[0,0],[1,1]]
    end

    it 'adds data on initialization' do
      series = DataSeries.new x_name: :x_name, y_name: :y_name, data: [{x_name: 0, y_name: 0, something: 1}, {x_name: 1, y_name: 1, something: 2} ]
      series.data.should eq [[0,0],[1,1]]
    end

    it 'initializes axes' do
      series = DataSeries.new(x_name: :age, y_name: :weight, x_label: "Age", y_label: "Weight",
                              x_units: "Years", y_units: "kg" )
      series.x_axis.should == {'name' => :age, 'units' => "Years", 'label' => "Age"}
      series.y_axis.should == {'name'  => :weight, 'units' =>  "kg", 'label' =>  "Weight"}
    end

    it 'initializes axes with default axis labels' do
      series = DataSeries.new(x_name: :age, y_name: :body_weight, x_units: "Years", y_units: "kg" )
      series.x_axis.should == {'name' => :age, 'units' => "Years", 'label' => "Age"}
      series.y_axis.should == {'name'  => :body_weight, 'units' =>  "kg", 'label' =>  "Body weight"}
    end

  end

end