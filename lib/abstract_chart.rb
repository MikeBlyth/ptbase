module AbstractChart

  class Chart < DelegateClass(Hash)
    def initialize(params=nil)
      super
    end

    def add_series(data_series)
      self[:series] = (self[:series] || []) <<  data_series
    end

    def data_for_morris
      DataSeries.merge_as_hash(self[:series])
    end

    def data_for_highchart
      self[:series].map {|s| s.to_highchart}
    end
  end

  class Axis < DelegateClass(Hash)
    def render(options={})
      attrs = options[:attrs] || self.keys   # I.e. everything
      excluded = options[:exclude] || [:something]
      self[:id] = options[:id] if options[:id]
      rendered = self.select{|k,v| attrs.include?(k) && !excluded.include?(k)}
      rendered.merge!(options[:extra]) if options[:extra]
      rendered
    end

    def render_highchart(options={})
      self.render(options).merge!(title: {text: self[:label]}) unless options[:title]
    end
  end

  class DataArray < Array
    attr_accessor :x_name, :y_name
    def initialize(params={})     # DataArray.new(x_name: :age, y_name: :weight, data: [[0,3], [1, 10]])
      @x_name = params[:x_name] || :x
      @y_name = params[:y_name] || :y
      data = normalize(params[:data])
      super(data || [])
    end

    # Convert hash array to xy array, extracting the x and y as specified by x_name and y_name
    # Omit points where y is nil
    # Given x_name = 'age' and y_name = 'weight',
    #   [{age: 0, other: 52, weight: 3}, {age: 0.5, other: 70}, {age: 1, other: 80, weight: 10}] ==> [[0,3], [1,10]]
    def normalize(data)
      return data unless data and data[0].is_a? Hash
      data.map do |data_point|
        x_value = value_w_indifferent_key(data_point, @x_name)
        y_value = value_w_indifferent_key(data_point, @y_name)
#        puts "data_point=#{data_point}, x_name=#@x_name, y_name=#@y_name, x=#{data_point[@x_name]}, y=#{y_value}"
        [x_value, y_value] if y_value
      end.compact
    end

    # Is there a better way to do this? Use dup? Something else?
    def +(data)
      DataArray.new(x_name: @x_name, y_name: @y_name, data: super(normalize(data)))
    end

    def to_simple_hash  # e.g. [ [0,3], [1,10]] -> {'weight' => {0=>3, 1=>10} }
      val_hash = {}
      self.each {|point| val_hash[point[0]] = point[1]}
      {@y_name => val_hash}
    end

    def to_labeled_hash # e.g. [ [0,3], [1,10]] -> {:age => 3, :weight => 10}
      self.map {|xy| {@x_name => xy[0], @y_name => xy[1]}}
    end

  private
    def value_w_indifferent_key(hash,key)
      hash[key.to_s] || hash[key.to_sym]
    end
  end


  class DataSeries < DelegateClass(Hash)
    def initialize(params)
      params[:data] = DataArray.new(params)
      super
      #self[:data] ||= []
      #self[:x_axis] ||= Axis.new(name: self[:x_name], units: params[:x_units], label: params[:x_label] || self[:x_name].to_s.humanize )
      #self[:y_axis] ||= Axis.new(name: self[:y_name], units: params[:y_units], label: params[:y_label] || self[:y_name].to_s.humanize )
    end

    def add_data(data)
      return if data.nil?
      self[:data] += data
    end

    def to_highchart(options={})
      reject_attributes = [:x_axis, :y_axis, :x_name, :y_name, :x_label]
      self[:name] = self[:x_label]
      self.reject {|k,v| reject_attributes.include? k}.merge(options)
    end

    # Take one or more DataSeries and return an array of hashes with one hash per x_value, e.g.
    # weights = DataSeries.new(x_name: age, y_name: weight, data: [[0,3], [1,10]])
    # heights = DataSeries.new(x_name: age, y_name: height, data: [[0, 52], [1,80]])
    # DataSeries.merge_as_hash([weights, heights]) #=>
    #    [{age: 0, weight: 3, height: 52}, {age: 1, weight: 10, height: 80}]
    def self.merge_as_hash(series_array)
      all_series_hash = {}
#binding.pry
      x_names = series_array.map{|s| s[:x_name]}.uniq
      raise "Cannot merge series with different x axes (#{x_names})" if x_names.count > 1
      x_name = x_names.first  # the common x_axis
      series_array.each {|s| all_series_hash.merge! s[:data].to_simple_hash} # e.g. { weight: {0=>3, 1=>10}, height: {0=>52, 1=>80} }
      x_points = all_series_hash.map {|k,v| v.keys}.flatten.uniq.sort
      x_points.map do |x|    # Make a data point hash for each x value
        xhash = {x_name => x}
        # Add each existing y value, giving, e.g., {..., 'weight'=>3.5, 'height'=>60, 'cd4'=>1400}
        all_series_hash.each {|y_name, point_hash| xhash[y_name] = point_hash[x] if point_hash[x] }
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
        xhash[self.y_name] = self_hash[x] if self_hash[x]
        xhash[other_series.y_name] = other_hash[x] if other_hash[x]
        xhash
      end
    end

    def to_hash_array
      self[:data].map {|d| {self[:x_name] => d[0], self[:y_name] => d[1]}}
    end
  private

    def data_from_array_of_hashes(data)
#binding.pry
      self[:data].map do |data_point|
        [data_point[self[:x_name]], data_point[self[:y_name]]]
      end
    end

  end

  class Annotation < Hash
    def initialize(params)
      super
    end
  end
end