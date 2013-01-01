class GrowthChart < AbstractChart
  include GrowthChartRefLines
  include NamesHelper

  DEFAULT_WIDTH = 600
  THUMB_WIDTH = 200

  def initialize(patient, options={})
    @patient = patient
    params = {title: make_title(), subtitle: make_subtitle(), series: make_series(), options: options}
    super(params)
  end

  def make_title
    @patient.name_id
  end

  def make_subtitle
    "DOB: #{@patient.birth_date}; Chart Date: #{Date.today}"
  end

  def make_series
    wt_ht_data = get_weight_height_points

  end
  ### GET THE ACTUAL DATA FROM THE PATIENT VISITS
  def get_weight_height_points
    @patient.ptvisits.select {|visit| plottable_wt_ht?(visit)}.map do |visit|
      {age: patient.age_on_date_in_years(visit.date),
       weight: visit.weight,
       height: visit.height}
    end
  end

  # Return true/false for whether this set of labs has any that should be plotted
  def plottable_wt_ht?(visit)
    lab.cd || lab.cd4pct
    # add other labs to condition if they're to be plotted also
  end

  # Return true/false for whether this set of labs has any that should be plotted
  def plottable_lab_values?(lab)
    lab.cd || lab.cd4pct
    # add other labs to condition if they're to be plotted also
  end

  def get_lab_points
    @patient.ptlabs.select {|lab| plottable_lab_values?(lab)}.each do |lab|
      age = patient.age_on_date_in_years(lab.date)           # calculate age on the date of this report
      @chart_data[age] ||= {}
      @chart_data[age].merge!({cd4: lab.cd4, cd4pct: lab.cd4pct})
    end
  end

  def generate_standard_curves
    if patient.sex == "M"
      percentile_wt_50  = PERCENTILE_WT_50_MALE
      percentile_ht_50 = PERCENTILE_HT_50_MALE
    else
      percentile_wt_50  = PERCENTILE_WT_50_FEMALE
      percentile_ht_50 = PERCENTILE_HT_50_FEMALE
    end
    percentile_wt_50.each do |point|
      @chart_data[point[0].to_f] ||= {}
      @chart_data[point[0].to_f][:wt_50pct] = point[1]
    end
    percentile_ht_50.each do |point|
      @chart_data[point[0].to_f] ||= {}
      @chart_data[point[0].to_f][:ht_50pct] = point[1]
    end
  end

  def generate_chart
    patient = @patient
    patient_age = patient.age_in_years
    g = Gruff::Xy.new(@size)
    g.title = "#{patient.name_id}"
    g.theme_37signals

    # Set min/max values for graphing

    draw_axes(g, axis_limits(patient_age))
    draw_data_series(g)
    g.write(@filename)
    @filename = "public/images/growthcharts/growthchart#{@patient.id}#{suffix}.png"
    return @filename
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