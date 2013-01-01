module AbstractChart < HashWithIndifferentAccess

  class Chart
    def initialize(params)
      super
    end
  end

  class Axis < HashWithIndifferentAccess
    def initialize(axis_params)
      super
    end
  end

  class DataSeries
    def initialize(params)
      x_name = params[:x_name]
      y_name = params[:y_name]
      raw_data = params[:data]
      @x_axis = Axis.new(name: x_name, units: params[:x_units], label: params[:x_label] )
      @y_axis = Axis.new(name: y_name, units: params[:y_units], label: params[:y_label] )
      @data = []
      add_data(raw_data) if raw_data
    end

    def add_data(data)
      return if data.nil?
      @data << (data.is_a? Hash ? data_from_array_of_hashes(data) : data )
    end

    def data_from_array_of_hashes(data)
      x_name = data[:select_x]
      y_name = data[:select_y]
      data[:points].map do |data_point|
        [data_point[x_name], data_point[y_name]]
      end
    end

  end

  class Annotation < HashWithIndifferentAccess
    def initialize(params)
      super
    end
  end
end