module AbstractChart

  class Chart < HashWithIndifferentAccess
    def initialize(params={})
      params[:series] ||= []
      super
    end

    def add_series(data_series)
      self[:series] << data_series
    end

    def data_for_morris
      DataSeries.merge_as_hash(self[:series])
    end
  end

  class Axis < HashWithIndifferentAccess
    def initialize(axis_params)
      super
    end

  end

  class DataSeries
    attr_accessor :x_name, :y_name, :data, :x_axis, :y_axis
    def initialize(params)
      @x_name = params[:x_name]
      @y_name = params[:y_name]
      data = params[:data]
      @x_axis = Axis.new(name: @x_name, units: params[:x_units], label: params[:x_label] || @x_name.to_s.humanize )
      @y_axis = Axis.new(name: @y_name, units: params[:y_units], label: params[:y_label] || @y_name.to_s.humanize )
      @data = []
      add_data(data)
    end

    def add_data(data)
      return if data.nil?
      if data[0].is_a? Hash
        @data +=  data_from_array_of_hashes(data)
      else
        @data += data
      end
    end

    def to_simple_hash
      simple_hash = {}
      data.each {|point| simple_hash[point[0]] = point[1]}
      simple_hash
    end

    def self.merge_as_hash(series_array)
      all_series_hash = {}
      x_names = series_array.map{|s| s.x_name}.uniq
      raise "Cannot merge series with different x axes (#{x_names})" if x_names.count > 1
      x_name = x_names.first
      series_array.each {|s| all_series_hash[s.y_name] = s.to_simple_hash}
      x_points = all_series_hash.map {|k,v| v.keys}.flatten.uniq.sort
      x_points.map do |x|    # Make a data point hash for each x value
        xhash = {x_name => x}
        # Add each existing y value, giving, e.g., {..., 'weight'=>3.5, 'height'=>60, 'cd4'=>1400}
        all_series_hash.each {|y_name, point_hash| xhash[y_name] = point_hash[x] if point_hash[x] }
        xhash
      end
    end

    def to_merged_hash(other_series)
      raise "Cannot merge series with different x axes ('#@x_name' and '#{other_series.x_name}')" unless @x_name == other_series.x_name
      self_hash = self.to_simple_hash
      other_hash = other_series.to_simple_hash
      x_points = (self_hash.keys + other_hash.keys).uniq.sort
      x_points.map do |x|
        xhash = {@x_name => x}
        xhash[self.y_name] = self_hash[x] if self_hash[x]
        xhash[other_series.y_name] = other_hash[x] if other_hash[x]
        xhash
      end
    end

    def to_hash_array
      data.map {|d| {@x_name => d[0], @y_name => d[1]}}
    end
  private

    def data_from_array_of_hashes(data)
#binding.pry
      data.map do |data_point|
        [data_point[@x_name], data_point[@y_name]]
      end
    end

  end

  class Annotation < HashWithIndifferentAccess
    def initialize(params)
      super
    end
  end
end