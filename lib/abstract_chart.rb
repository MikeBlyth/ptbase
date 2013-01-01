module AbstractChart

  class Chart < HashWithIndifferentAccess
    def initialize(params={})
      params[:series] ||= []
      super
    end

    def add_series(data_series)
      self[:series] << data_series
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
      @y_axis = Axis.new(name: @y_name, units: params[:y_units], label: params[:y_label] || @x_name.to_s.humanize )
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