class GrowthChart
  include GrowthChartRefLines

  DEFAULT_WIDTH = 600
  THUMB_WIDTH = 200

  def initialize(patient, options={})
    @patient = patient
    if options[:thumb]
        @size = THUMB_WIDTH
        suffix = '_thumb'
    else
        @size = DEFAULT_WIDTH
        suffix = ''
    end
    @filename = "public/images/growthcharts/growthchart#{@patient.id}#{suffix}.png"
    generate_chart
    return @filename
  end

  def generate_chart
    patient = @patient
    patient_age = patient.age_in_years
    g = Gruff::Xy.new(@size)
    g.title = "#{patient.name_id}"
    g.theme_37signals


    # Create array of [age (in years), weight] points
    growth_points_weight = []
    growth_points_height = []
    cd4_points = []
    cd4_pct = []

    ### GET THE ACTUAL DATA FROM THE PATIENT VISITS
    def get_weight_height_points
      @patient.ptvisits.each do |visit|
        wt_1 = visit.weight
        ht_1 = visit.ht
        age_1 = patient.age_on_date_in_years(visit.date)
        growth_points_weight << [age_1, wt_1] if wt_1 && wt_1 > 0     # append weight to array
        growth_points_height << [age_1, ht_1] if ht_1 && ht_1 > 0     # append height to its array
      end
    end

    def get_lab_points
      @patient.ptlabs.each do |lab|
        next if ((lab.cd4 || 0) == 0) && ((lab.cd4pct || 0) == 0)  # skip if nothing to plot
        age_1 = patient.age_on_date_in_years(lab.date)           # calculate age on the date of this report
        cd4_points << [age_1, lab.cd4] if (lab.cd4 || 0) > 0     # append cd4 count to array
        cd4_pct << [age_1, lab.cd4pct] if (lab.cd4pct || 0) > 0     # append cd4pct to array
      end
    end

    if patient.sex == "M"
      percentile_wt_50  = PERCENTILE_WT_50_MALE
      percentile_ht_50 = PERCENTILE_HT_50_MALE
    else
      percentile_wt_50  = PERCENTILE_WT_50_FEMALE
      percentile_ht_50 = PERCENTILE_HT_50_FEMALE
    end

    # Set min/max values for graphing

    draw_axes(g, axis_limits(patient_age))
    draw_data_series(g)
    # this writes the file to the hard drive for caching
    # and then writes it to the screen.
    g.write(@filename)
  end # of growth chart

  def draw_axes(g, limits)
    axis_ht = g.add_axis({:name => "Height", :axis_type => :y_axis, :position => :right, :min => 0, :max => limits[:ht_max], :label_interval => 20, :do_lines => false, :do_labels => false })
    axis_cd4 = g.add_axis({:name => "CD4", :axis_type => :y_axis, :position => :right, :min => 0, :max => 2000, :label_interval => 200, :do_lines => false })
    #    axis_cd4pct = g.add_axis({:name => "CD4%", :axis_type => :y_axis, :position => :right, :min => 0, :max => 50, :label_interval => 5, :do_lines => false })
    axis_wt = g.add_axis({:name => "Weight", :min => limits[:wt_min], :max => limits[:wt_max], :line_interval => 10, :label_interval => 20, :axis_type => :y_axis, :position => :left})
    axis_age = g.add_axis({:name => "Age", :min => limits[:age_min], :max => limits[:age_max], :line_interval => 1, :label_interval => 2, :axis_type => :x_axis,
                           :pointsize => 20})
    [axis_ht, axis_cd4, axis_wt, axis_age].each {|axis| axis.draw(g)}
  end

  def draw_data_series(g)
    g.data({:name => "Weight", :data_points => growth_points_weight, :color => "green4", :axis => axis_wt})
    g.data({:name => "Height", :data_points => growth_points_height, :color => "blue", :axis => axis_ht})
    g.data({:name => "Wt Std", :data_points => percentile_wt_50, :line_width => 2, :marker => :none, :color => "PaleGreen2", :axis => axis_wt})
    g.data({:name => "Ht Std", :data_points => percentile_ht_50, :line_width => 2, :marker => :none, :color => "SkyBlue3", :axis => axis_ht})
    if cd4_points != []
      g.data({:name => "CD4", :data_points => cd4_points, :color => "red", :axis => axis_cd4})
      g.data({:name => "", :data_points => CD4_SEVERE, :color => "red", :marker => :none,  :line_width => 2, :axis => axis_cd4})
    end
    if cd4_pct != []
      g.data({:name => "CD4%%", :data_points => cd4_pct, :color => "purple1", :axis => axis_wt})
      g.data({:name => "", :data_points => CD4PCT_SEVERE, :color => 'purple1', :marker => :none,  :line_width => 2, :axis => axis_wt})
    end
    #    g.data({:name => "CD4-1", :data_points => cd4_moderate, :color => "orange", :axis => axis_cd4})
  end

  def axis_limits(patient_age)
    case
      when patient_age > 18
        {age_max:  patient_age.ceil + 1 ,
         age_min: 12,
         wt_max: 100,
         wt_min: 20,
         ht_max: 190}
      when patient_age.between?(10,18)
        {age_max: 19,
         age_min: 8 ,
         wt_max: 100,
         wt_min: 0 ,
         ht_max: 190}
      when patient_age.between?(5,10)
        {age_max: 11,
         age_min: 3,
         wt_max: 60 ,
         wt_min: 0,
         ht_max: 160}
      else
        {age_max: 5,
         age_min: 0,
         wt_min: 0,
         wt_max: 30,
         ht_max: 130 }
    end
  end

end