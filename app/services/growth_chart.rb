require 'abstract_chart'

class GrowthChart < AbstractChart::Chart
  include GrowthChartRefLines
  include NamesHelper

  attr_accessor :patient

  def initialize(patient, options={})
    @patient = patient
    super({title: make_title(), subtitle: make_subtitle(),
           chart_type: :line, div: 'growth_chart', options: options})
  end

  def add_all_series
    add_non_empty_series(:weight, :height, :cd4, :cd4pct, :weight50, :height50)
  end

  def add_non_empty_series(*series_names)
    series_names.each do |name|
      s = self.send "#{name}_series"
      add_series s unless s.empty?
    end
  end

  def add_all_axes
    add_axis AbstractChart::Axis.new({orientation: :x, name: :age, min: 0, max: 18, label: "Age"})
    add_axis AbstractChart::Axis.new({orientation: :y, name: :weight, min: 0, max: 100, label: "Wt"})
    add_axis AbstractChart::Axis.new({orientation: :y, name: :height, min: 40, max: 180, label: "Ht"})
    add_axis AbstractChart::Axis.new({orientation: :y, name: :cd4, min: 0, max: 2000, label: "CD4"})
    add_axis AbstractChart::Axis.new({orientation: :y, name: :cd4pct, min: 0, max: 70, label: "CD4 %"})
  end

  def make_title
    @patient.name_id
  end

  def make_subtitle
    "DOB: #{@patient.birth_date}; Chart Date: #{Date.today}"
  end

  def weight_series
    AbstractChart::DataSeries.new(x_name: :age, y_axis: :weight,  y_label: 'Weight (kg)', data: visit_data)
  end

  def height_series
    AbstractChart::DataSeries.new(x_name: :age, y_axis: :height, y_label: 'Height (cm)', data: visit_data)
  end

  def cd4_series
    AbstractChart::DataSeries.new(x_name: :age, y_axis: :cd4, data: lab_data, y_label: 'CD4')
  end

  def cd4pct_series
    AbstractChart::DataSeries.new(x_name: :age, y_axis: :cd4pct, data: lab_data,  y_label: 'CD4%')
  end

  ### GET THE ACTUAL DATA FROM THE PATIENT VISITS
  # ToDo - use a proper db query ("where...") instead of plottable_wt_ht? and plottable_lab_values
  def visit_data
    @visit_data ||= @patient.visits.select {|visit| plottable_wt_ht?(visit)}.map do |visit|
      {age: patient.age_on_date_in_years(visit.date),
       weight: visit.weight,
       height: visit.height}
    end
  end

  def lab_data
    @lab_data ||= @patient.labs.select {|lab| plottable_lab_values?(lab)}.map do |lab|
      {age: patient.age_on_date_in_years(lab.date),
       cd4: lab.cd4,
       cd4pct: lab.cd4pct}
    end
  end

  # Return true/false for whether this set of labs has any that should be plotted
  def plottable_wt_ht?(visit)
    visit.weight || visit.height
  end

  # Return true/false for whether this set of labs has any that should be plotted
  def plottable_lab_values?(lab)
    lab.cd4 || lab.cd4pct
    # add other labs to condition if they're to be plotted also
  end

  def add_std_anthro_series
    self.add_series weight50_series
    self.add_series height50_series
  end

  def weight50_series
    standards = (@patient.sex == "M") ? PERCENTILE_WT_50_MALE : PERCENTILE_WT_50_FEMALE
    AbstractChart::DataSeries.new(y_axis: :weight, x_name: :age, y_label: 'Weight 50%ile', data: standards)
  end

  def height50_series
    standards = (@patient.sex == "M") ? PERCENTILE_HT_50_MALE : PERCENTILE_HT_50_FEMALE
    AbstractChart::DataSeries.new(y_axis: :height, x_name: :age, y_label: 'Height 50%ile', data: standards)
  end

  def cd4_moderate_series
    AbstractChart::DataSeries.new(y_axis: :cd4, x_name: :age, y_label: 'CD4 Moderate', data: CD4_MODERATE)
  end

  def cd4_severe_series
    AbstractChart::DataSeries.new(y_axis: :cd4, x_name: :age, y_label: 'CD4 Severe', data: CD4_SEVERE)
  end

  def cd4pct_severe_series
    AbstractChart::DataSeries.new(y_axis: :cd4pct, x_name: :age, y_label: 'CD4% Severe',data: CD4PCT_SEVERE)
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