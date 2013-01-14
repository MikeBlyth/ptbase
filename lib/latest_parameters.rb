require 'anthropometrics'


#ToDo -- think about problem of outdated values esp. weight & height. Consumer beware?
class LatestParameters < Hash
  attr_accessor :from_tables

  DEFAULT_PARAMS =  {
      :cd4 => {:table => LabResult, :label => "Latest CD4"},
      :cd4pct => {:table => LabResult, :label => "Latest CD4%", :unit => '%'},
      :comment_cd4 => {:table => LabResult, :label => "CD4 comment"},
      :comment_hct => {:table => LabResult, :label => "Hct comment"},
      :hct => {:table => LabResult, :label => "Latest hct", :unit => '%'},
      :weight => {:table => Visit, :label => "Latest weight", :unit => ' kg'},
      :height => {:table => Visit, :label => "Latest height", :unit => ' cm'},
      :meds => {:table => Visit, :label => "Latest meds"},
      :hiv_stage => {:table => Visit, :label => "HIV stage"}
  }

  def initialize(patient)
    @from_tables = DEFAULT_PARAMS
    self[:patient_id] = patient.id
    self[:patient] = patient
    self[:sex] = patient.sex
    self[:latest_visit] = patient.visits.latest
    load_from_visits
  end

  def load_from_visits(*items)
    items = DEFAULT_PARAMS.select {|k,v| v[:table] == Visit}.keys if items.empty?
    visit_data = self[:patient].visits.select('date,' + items.join(',')).order('date desc')
    items.each do |item|
      latest_match = visit_data.find {|v| v.send(item)}    # i.e. find latest visit with non-nil item of interest
      insert_item({item: item, date: latest_match.date, value: latest_match.send(item)}) if latest_match
    end
  end

  def load_from_labs(*items)
    items = DEFAULT_PARAMS.select {|k,v| v[:table] == LabResult}.keys if items.empty?
    results = LabResult.get_selected_labs_by_date(self[:patient], nil, items)  # MUST be sorted by desc date
    items.each do |item|
      latest_match = results.find {|r| r.lab_service.abbrev.to_s == item.to_s}
      insert_item({item: item, date: latest_match.date, value: latest_match.result}) if latest_match
    end
  end

  # Given {item: :weight, date: Date.today, value: 30.0, something_else: 'Really?'}, insert
  # self[:weight] = {date: Date.today, value: 30.0, something_else: 'Really?'}
  def insert_item(item_hash)
    self[item_hash.delete(:item)] = item_hash #  (Remembering that Hash.delete returns the value of the deleted key)
  end

  # ToDo - Add warning, or fail to perform anthropometrics, if dates are not reasonably equal
  def add_anthropometrics
    # Calculate expected weight, ht, wt for height etc.
    # Note that expected height will not be accurate unless height date ~ weight date
    if self[:weight]
      weight_date = self[:weight][:date]
      weight = self[:weight][:value]
    else
      weight_date = weight = nil
    end
    if self[:height]
      height_date = self[:height][:date]
      height = self[:height][:value]
    else
      height_date = height = nil
    end
    anthro_inputs = {
        sex: self[:sex],
        height: height,
        weight: weight,
        age: self[:patient].age_on_date_in_years(weight_date || height_date)
    }
    self[:bsa] = {:value => body_surface_area(anthro_inputs)}
    self[:pct_expected_ht] = {:value => pct_expected_height(anthro_inputs) || '?'}
    self[:pct_expected_wt] = {:value => pct_expected_weight(anthro_inputs) || '?'}
    self[:pct_expected_wt_for_ht] = {:value => pct_expected_weight_for_height(anthro_inputs) || '?'}
    return self
  end


  # Reminders about needed labs
  # Given the item to check, add the message if there is no result for item within past interval days
  def add_reminder(params)
    item = params[:item]
    return self unless item
    message = set_message(params)
    interval_days = params[:interval_days] || 150
    target = self[item] || {}   # The hash of the item in question, e.g. self[:cd4] -> {:value=> 300, :date => '2009-04-04',... }
    date = target[:date]  # The date of the last result of that item
    unless date && (DateTime.now - date.to_datetime) < interval_days
      self["comment_#{item}".to_sym] = {:label => "Note", :value => message}
    end
    return self
  end

  def value(item)
    self[item] ? self[item][:value] : nil
  end

private

  # Get that most recent *parameter* from *table*
  #    'get_last(self.visits, :weight)')
  # TODO: make a method of ActiveRecord?
  def get_last(table,parameter)
    condition = ["#{parameter} IS NOT ?", nil]
#binding.pry if parameter == 'hct'
    most_recent = table.where('patient_id = ?', self[:patient_id]).where(condition).order('date DESC').first
    return nil if most_recent.nil?
    lastvalue = most_recent.send(parameter)
    lastdate = most_recent.date
    return {:value => lastvalue, :date => lastdate }
  end

  #  If params[:item] = 'hct',
  #  "patient is due for hct check" or, if e.g. params[:message] = "Better check the $!"
  #  "Better check the hct"
  def set_message(params)
    message = params[:message]
    item = params[:item]
    if message.nil?
      return "patient is due for #{item} check"
    else
      return message.gsub('$', item.to_s)
    end
  end

end