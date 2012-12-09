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
  end

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
    #Todo: this method should not have responsibility of formatting the date
    return {:value => lastvalue, :date => lastdate }
  end

end