require 'forwardable'

module AbstractChart

  class Chart
    attr_accessor :axes, :series, :options, :title, :chart_type, :div

    def initialize(params={})
      @chart_type = params[:chart_type] ||= :line
      @div = params[:div] ||=  'chart-div'
      @title = params[:title] || 'Title'
      @axes = params[:axes] || []
      @series = params[:series] ||= []
      @options = params[:options] || {}
    end

    def add_series(*data_series)
      @series += data_series
    end

    def add_axis(*axis)
      @axes += axis
    end

    def render_axes_to_highchart
      {xAxis: selected_x_axes.map {|a| a.render_highchart},
       yAxis: selected_y_axes.map {|a| a.render_highchart}
      }
    end

    def selected_x_axes
      @selected_x_axes ||= selected(x_axes)
    end

    def selected_y_axes
      @selected_y_axes ||= referenced_y_axes
    end

    def x_axes
      @axes.select {|axis| axis[:orientation] == :x}
    end

    def y_axes
      @axes.select {|axis| axis[:orientation] == :y}
    end

    def selected(elements)
#binding.pry
      elements.select {|e| !e[:ignore] && !(e[:auto_hide] && e.empty?)}
    end

    def referenced_y_axes
      y_axes.select {|axis| referenced_y_axis_names.include? axis[:name]}
    end

    # the y_axis names referenced by selected series
    def referenced_y_axis_names
      selected_series.map {|s| s[:y_axis]}.compact
    end

    def selected_series
      @selected_series ||= selected(@series)
    end

    def render_series_to_highchart
      {series: selected_series.map {|s| s.to_highchart.merge(y_axis_index(s))}}
    end

    def y_axis_index(series)
      {yAxis: selected_y_axes.find_index {|a| a[:name] == series[:y_axis]}  }
    end

    def chart_base
      {chart: {renderTo: @div, type: @chart_type}, title: {text: @title}}
    end

    def data_for_morris
#binding.pry
      DataSeries.merge_as_hash(@series)
    end

    def render_to_highchart
<<HIGHCHART
$(document).ready(function() {
  chart1 = new Highcharts.Chart(
     #{chart_base.merge(render_axes_to_highchart).merge(render_series_to_highchart).to_json}
  )
})
HIGHCHART
    end

    def data_for_highchart
      self[:series].map {|s| s.to_highchart}
    end
  end

  class Axis < DelegateClass(Hash)
    def initialize(options={})
      options[:orientation] ||= :y
      options[:label] ||= options[:name].to_s.humanize
      super
    end

    def render(options={})
      attrs = options[:attrs] || self.keys   # I.e. everything
      excluded = options[:exclude] || [:something]
      self[:id] = options[:id] if options[:id]
                                             #noinspection RubyArgCount
      rendered = self.select { |k, v| attrs.include?(k) && !excluded.include?(k) }
      rendered.merge!(options[:extra]) if options[:extra]
      rendered
    end

    def render_highchart(options={})
      self.render(options).merge!(title: {text: self[:label]}) unless options[:title]
    end
  end

  class DataArray < Array
    attr_accessor :x_name, :y_axis
    def initialize(params={})     # DataArray.new(x_name: :age, y_axis: :weight, data: [[0,3], [1, 10]])
      @x_name = params[:x_name] || :x
      @y_axis = params[:y_axis] || :y
      @y_label = params[:y_label] || @y_axis #.to_s.humanize
      data = normalize(params[:data])
      super(data || [])
    end

    # Convert hash array to xy array, extracting the x and y as specified by x_name and y_axis
    # Omit points where y is nil
    # Given x_name = 'age' and y_axis = 'weight',
    #   [{age: 0, other: 52, weight: 3}, {age: 0.5, other: 70}, {age: 1, other: 80, weight: 10}] ==> [[0,3], [1,10]]
    def normalize(data)
      return data unless data and data[0].is_a? Hash
      data.map do |data_point|
        x_value = value_w_indifferent_key(data_point, @x_name)
        y_value = value_w_indifferent_key(data_point, @y_axis)
#        puts "data_point=#{data_point}, x_name=#@x_name, y_axis=#@y_axis, x=#{data_point[@x_name]}, y=#{y_value}"
        [x_value, y_value] if y_value
      end.compact
    end

    # Is there a better way to do this? Use dup? Something else?
    def +(data)
      DataArray.new(x_name: @x_name, y_axis: @y_axis, data: super(normalize(data)))
    end

    def to_simple_hash  # e.g. [ [0,3], [1,10]] -> {'weight' => {0=>3, 1=>10} }
      val_hash = {}
      self.each {|point| val_hash[point[0]] = point[1]}
      {@y_label => val_hash}
    end

    def to_labeled_hash # e.g. [ [0,3], [1,10]] -> {:age => 3, :weight => 10}
      self.map {|xy| {@x_name => xy[0], @y_axis => xy[1]}}
    end

  private
    def value_w_indifferent_key(hash,key)
      hash[key.to_s] || hash[key.to_sym]
    end
  end


  class DataSeries < DelegateClass(Hash)

    def initialize(params)
      params[:data] = DataArray.new(params)
      raise "Missing y axis name for DataSeries #{params}" if params[:y_axis].nil?
      params[:auto_hide] = !(params[:auto_hide] == false)
      super
    end

    def add_data(data)
      return if data.nil?
      self[:data] += data
    end

    def any?
      self[:data].any?
    end

    def empty?
      self[:data].empty?
    end

    def to_highchart(options={})
      reject_attributes = [:x_axis, :x_name, :x_label, :y_label]
      self[:name] = (self[:y_label] || self[:name]).to_s.humanize
      self.reject {|k,v| reject_attributes.include? k}.merge(options)
    end

    # Take one or more DataSeries and return an array of hashes with one hash per x_value, e.g.
    # weights = DataSeries.new(x_name: age, y_axis: weight, data: [[0,3], [1,10]])
    # heights = DataSeries.new(x_name: age, y_axis: height, data: [[0, 52], [1,80]])
    # DataSeries.merge_as_hash([weights, heights]) #=>
    #    [{age: 0, weight: 3, height: 52}, {age: 1, weight: 10, height: 80}]
    def self.merge_as_hash(series_array)
      all_series_hash = {}
      x_names = series_array.map{|s| s[:x_name]}.uniq
      raise "Cannot merge series with different x axes (#{x_names})" if x_names.count > 1
      x_name = x_names.first  # the common x_axis
      series_array.each {|s| all_series_hash.merge! s[:data].to_simple_hash} # e.g. { weight: {0=>3, 1=>10}, height: {0=>52, 1=>80} }
      x_points = all_series_hash.map {|k,v| v.keys}.flatten.uniq.sort
      x_points.map do |x|    # Make a data point hash for each x value
        xhash = {x_name => x}
        # Add each existing y value, giving, e.g., {..., 'weight'=>3.5, 'height'=>60, 'cd4'=>1400}
        all_series_hash.each {|y_axis, point_hash| xhash[y_axis] = point_hash[x] if point_hash[x] }
        xhash
      end
    end

    def to_merged_hash(other_series)
      raise "Cannot merge series with different x axes ('#self[:x_name]' and '#{other_series.x_name}')" unless self[:x_name] == other_series.x_name
      self_hash = self.to_simple_hash
      other_hash = other_series.to_simple_hash
      x_points = (self_hash.keys + other_hash.keys).uniq.sort
      x_points.map do |x|
        xhash = {self[:x_name] => x}
        xhash[self.y_axis] = self_hash[x] if self_hash[x]
        xhash[other_series.y_axis] = other_hash[x] if other_hash[x]
        xhash
      end
    end

    def to_hash_array
      self[:data].map {|d| {self[:x_name] => d[0], self[:y_axis] => d[1]}}
    end
  private

    def data_from_array_of_hashes(data)
#binding.pry
      self[:data].map do |data_point|
        [data_point[self[:x_name]], data_point[self[:y_axis]]]
      end
    end

  end

  class Annotation < Hash
    def initialize(params)
      super
    end
  end
end