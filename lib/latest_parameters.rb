require 'anthropometrics'

class LatestParameters < Hash
  attr_accessor :from_tables

  DEFAULT_PARAMS =  {
      :cd4 => {:table => Lab, :label => "Latest CD4", :col => "cd4", :unit => ''},
      :cd4pct => {:table => Lab, :label => "Latest CD4%", :col => "cd4pct", :unit => '%'},
      :hct => {:table => Lab, :label => "Latest hct", :col => "hct", :unit => '%'},
      :weight => {:table => Visit, :label => "Latest weight", :col => "weight", :unit => ' kg'},
      :height => {:table => Visit, :label => "Latest height", :col => "height", :unit => ' cm'},
      :meds => {:table => Visit, :label => "Latest meds", :col => "meds", :unit => ''},
      :hiv_stage => {:table => Visit, :label => "HIV stage", :col => "hiv_stage", :unit => ''}
  }

  def initialize(patient)
    @from_tables = DEFAULT_PARAMS
    self[:patient_id] = patient.id
    self[:patient] = patient
    self[:sex] = patient.sex
    self[:latest_visit] = patient.visits.latest
  end

  # ToDo: may want to change this to let desired parameters be passed rather than being specified here in the method
  # ToDo: This could probably be optimized, not having to do separate SQL query for each parameter
  # Should look in the latest visit (see end of this procedure) for height, weight, etc. and
  # only look at other visits (get_last) if they're not recorded in the latest visit.

  def load_from_tables
    # Make hash of the parameters we *want* and where to find them
    @from_tables.each do |param, param_hash|
      self[param] = {label: param_hash[:label], col: param_hash[:col], unit: param_hash[:unit]}
      result = get_last(param_hash[:table], param_hash[:col])
      if result
        self[param].merge! result  # add the values, dates passed back by the search for latest parameters
        # Comment: this copies :table, :label, :col etc. so that we will have, e.g.,
        # self[:cd4] -> {:value=> 300, :date => '2009-04-04', :table => Lab, :label => "Latest CD4", :col => "cd4", :unit => ''}
      end
    end
    return self
  end

  def add_anthropometrics
    # Calculate expected weight, ht, wt for height etc.
    weight_date = self[:weight][:date]
    anthro_inputs = {
        sex: self[:sex],
        height: self[:height][:value],
        weight: self[:weight][:value],
        age: self[:patient].age_on_date_in_years(weight_date)
    }
    self[:pct_expected_ht] = {:value => pct_expected_height(anthro_inputs) || '?'}
    self[:pct_expected_wt] = {:value => pct_expected_weight(anthro_inputs) || '?'}
    self[:pct_expected_wt_for_ht] = {:value => pct_expected_weight_for_height(anthro_inputs) || '?'}
  end


    #   Reminders about needed labs
  def add_reminder(params)
    item = params[:param]
    return false if item.nil?
    message = params[:message] || "patient is due for #{item} check"
    interval_days = params[:interval_days] || 150
    target = self[item] # The hash, e.g. self[:cd4] -> {:value=> 300, :date => '2009-04-04',... }
    date = target[:date]
    return false if date.nil? || (DateTime.now - date) > interval_days
    self["comment_#{item}".to_sym] = {:label => "Note", :value => message}
    return true
  end

private

  # Get that most recent *parameter* from *table*
  #    'get_last(self.visits, :weight)')
  # TODO: make a method of ActiveRecord?
  def get_last(table,parameter)
    condition = ["#{parameter} IS NOT ?", nil]
    most_recent = table.where('patient_id = ?', self[:patient_id]).where(condition).order('date DESC').first
    return nil if most_recent.nil?
    lastvalue = most_recent.send(parameter)
    lastdate = most_recent.date
    return {:value => lastvalue, :date => lastdate }
  end

end