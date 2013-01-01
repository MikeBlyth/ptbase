require 'abstract_chart'

class GrowthChart < AbstractChart::Chart
  include GrowthChartRefLines
  include NamesHelper

  attr_accessor :patient

  DEFAULT_WIDTH = 600
  THUMB_WIDTH = 200

  def initialize(patient, options={})
    @patient = patient
    params = {title: make_title(), subtitle: make_subtitle(), options: options}
    super(params)
  end

  def add_all_series
    visit_data = get_visit_data
    lab_data = get_lab_data
    add_series weight_series(visit_data)
    add_series height_series(visit_data)
    add_series cd4_series(lab_data)
    add_series cd4pct_series(lab_data)
  end

  def make_title
    @patient.name_id
  end

  def make_subtitle
    "DOB: #{@patient.birth_date}; Chart Date: #{Date.today}"
  end

  def weight_series(visit_data)
    DataSeries.new(x_name: :age, y_name: :weight, x_units: 'Years', y_units: 'kg', data: visit_data)
  end

  def height_series(visit_data)
    DataSeries.new(x_name: :age, y_name: :height, x_units: 'Years', y_units: 'cm', data: visit_data)
  end

  def cd4_series(lab_data)
    DataSeries.new(x_name: :age, y_name: :cd4, x_units: 'Years', y_units: '', data: lab_data)
  end

  def cd4pct_series(lab_data)
    DataSeries.new(x_name: :age, y_name: :cd4pct, x_units: 'Years', y_units: '%', data: lab_data)
  end

  ### GET THE ACTUAL DATA FROM THE PATIENT VISITS
  # ToDo - use a proper db query ("where...") instead of plottable_wt_ht? and plottable_lab_values
  def get_visit_data
    @patient.visits.select {|visit| plottable_wt_ht?(visit)}.map do |visit|
      {age: patient.age_on_date_in_years(visit.date),
       weight: visit.weight,
       height: visit.height}
    end
  end

  def get_lab_data
    @patient.labs.select {|lab| plottable_lab_values?(lab)}.map do |lab|
      {age: patient.age_on_date_in_years(visit.date),
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
    lab.cd || lab.cd4pct
    # add other labs to condition if they're to be plotted also
  end

  def add_std_anthro_series
    if @patient.sex == "M"
      percentile_wt_50  = PERCENTILE_WT_50_MALE
      percentile_ht_50 = PERCENTILE_HT_50_MALE
    else
      percentile_wt_50  = PERCENTILE_WT_50_FEMALE
      percentile_ht_50 = PERCENTILE_HT_50_FEMALE
    end
    self.add_series DataSeries.new(y_name: :weight50, x_name: :age, y_units: 'kg', x_units: 'Years', y_label: 'Weight 50%ile',
                            data: percentile_wt_50)
    self.add_series DataSeries.new(y_name: :height50, x_name: :age, y_units: 'cm', x_units: 'Years', y_label: 'Height 50%ile',
                            data: percentile_ht_50)
  end

  def cd4_moderate_series
    DataSeries.new(y_name: :cd4_mod, x_name: :age, y_units: '', x_units: 'Years', y_label: 'CD4 Moderate',
                    data: CD4_MODERATE)
  end

  def cd4_severe_series
    DataSeries.new(y_name: :cd4_severe, x_name: :age, y_units: '', x_units: 'Years', y_label: 'CD4 Severe',
                    data: CD4_SEVERE)
  end

  def cd4pct_severe_series
    DataSeries.new(y_name: :cd4pct_severe, x_name: :age, y_units: '', x_units: 'Years', y_label: 'CD4% Severe',
                    data: CD4PCT_SEVERE)
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