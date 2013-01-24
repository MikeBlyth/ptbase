# == Schema Information
#
# Table name: immunizations
#
#  id          :integer          not null, primary key
#  patient_id  :integer

# NB This model is not used yet and it's not clear how it should be organized!
class Immunization < ActiveRecord::Base
  include DateValidators
  attr_protected
  belongs_to :patient
  belongs_to :provider
  belongs_to :immunization_type
  validates_presence_of :patient_id, :immunization_type, :date

  def to_s
    "#{immunization_type.abbrev} on #{date.to_date}"
  end

  # ToDo: Refactor
  def summary()
#Provide a summary of the immunization status. Returns a hash of form:
#  { imm_type => {:count => number_of_doses_recorded, :since => days_since_last_recorded_dose} }
#  Examples:
#    { 'dpt' => {:count => 3}, :since => 92},
#      'hib' => {:count => 1}, :since => 92} }
#    This represents someone who has three doses of dpt and one dose of hib. For both opv and hib, the last dose was 92 days ago.
#
#    summary['dpt'][:count] refers to the number of doses of DPT recorded
#    summary['hib'][:since] refers to the days since the last dose
#    If no immunization of a given type has been recorded, the :count will be zero and the :since will be nil.

    imm_summary = {:patient => self.patient}   # This is the main hash, to be returned
    # Get the names of all columns with type Date, as these are the immunizations
    columns = Immunization.content_columns.map {|c| c.name if c.type == :date}.compact.sort
    for column in columns
      imm_date = self.send(column.downcase)
      imm_type = column.downcase.gsub(/[0-9]/,'')   # Here just for clarity; it's the column name without the digit on the end
      imm_summary[imm_type] = {:count => 0, :since => nil} unless imm_summary.include?(imm_type)
      if imm_date.to_s > ''
#       return {:type => imm_type, :count => column[-1,1].to_i}
# Since the list is sorted, we can replace :count by the current imm number whenever we find it and we'll end up with the highest
        imm_summary[imm_type][:count] = column[-1,1].to_i   # the immunization number for this type of imm, e.g. 3 for Hib3
        imm_summary[imm_type][:since] = days_since(imm_date)
        imm_summary[imm_type][:last] = imm_date
      end
    end
    return assess_status(imm_summary)
  end

  def self.hib_needed(patient)
    # Using class method because the patient may not have an immunization record
    max_age = 5
    return false if patient.age_years > max_age
    hib_summary = Immunization.find_or_create_by_patient_id(patient.id).summary['hib']
    date_for_next = hib_summary[:next]
    return date_for_next && date_for_next <= Date.today
  end

  protected
  def validate
    birth = self.patient.birth
    columns = []
    Immunization.content_columns.each {| col | columns << col.name}  # Make array of column names
    columns.sort!
    last_col = ''
    last_date = DateTime.now  # I can't figure out why this needs to be initialized but it works
    columns.each do |col|
      next if ['reckey', 'put_more_keys_here_if_not_to_be_processed' ].include?(col)
      date = self.send(col)
      errors.add(col, "Invalid date") if !date.blank? && (date < birth || date > DateTime.now)
      if col[-1,1] > '1' && !date.blank?
        errors.add(col, "Out of order dates")  if last_date.blank? || last_date >= date
      end
      last_date = date
      last_col = col
    end
  end

  # ToDo: Refactor. The different immunization parameters should probably be set by related objects
  # with a strategy pattern
  def assess_status(summary)
    birth = summary[:patient].birth_date
    age = summary[:patient].age_years
    imms = summary.keys
    imms.delete(:patient)
    imms.each do |imm|
      summary[imm][:next] = imm + ': none'
    end
    summary[:age] = age

    # HIB
    next_dose = nil
    count = summary['hib'][:count]
    since = summary['hib'][:since]
    last = summary['hib'][:last]
    if since.nil?
      age_at_last = nil
    else
      age_at_last = age - (since/365) # This is age in years at the last Hib dose
    end
    case count
      when 0
        next_dose = Date.today if age.between?(6/52, 5)

      when 1
        # Interval = 4 weeks if first dose at < 12 months
        next_dose = last + 28 if ( age < 5 && age_at_last < 1 )
        # Interval = 8 weeks (as final dose) if first dose administered at age 12-14 months
        next_dose = last + 56 if ( age < 5 && age_at_last.between?(1, 1.25))

      when 2
        # Interval = 4 weeks if current age < 12 months
        next_dose = last + 28 if ( age < 5 && age_at_last < 1 )
        # Interval = 8 weeks current age > 12 months and second dose administered at age < 15 months
        next_dose = last + 56 if ( age.between?(1, 5) && age_at_last < 1.25)

      when 3
        next_dose = birth +  455 # 15 months of age
        next_dose = last + 56 if ( age.between?(1.25, 5) && age_at_last < 1 )
    end
    if next_dose
      next_dose = today.to_date if next_dose < today
      date_s = next_dose.to_s
      date_s = 'today' if next_dose == today
    else
      date_s = 'none'
    end
    summary = update_next_dose(summary, 'hib', next_dose)

    # Meningococcus
    next_dose = ''
    since = summary['mening'][:since]
    if since.nil? || since > 730    # if no previous immunization or imm > 2 years ago
      next_dose = today
      next_dose = birth + 0.75*365 if age < 0.75   # if less than nine months old, set next dose to when age is 9 months
    else
      next_dose = last + 730
    end
    summary = update_next_dose(summary, 'mening', next_dose)

    # Polio
    next_dose = ''
    count = summary['opv'][:count]
    since = summary['opv'][:since]
    last = summary['opv'][:last]
    if since.nil?
      age_at_last = nil
    else
      age_at_last = age - (since/365) # This is age in years at the last Hib dose
    end
    case count
      when 0
        next_dose = birth + 42  # first dose due at 6 weeks
      when 1..2
        next_dose = last + 28
      when 3
        if age_at_last < 4  # "fourth dose not needed if third given at older than 4 years of age"
          next_dose = last + 28
          next_dose = birth + (365*4) if (next_dose < birth + 365*4) # fourth dose given at min 4 years old (check Nigeria policy**
        end
    end
    summary = update_next_dose(summary, 'opv', next_dose)

    # DPT
    next_dose = ''
    count = summary['dpt'][:count]
    since = summary['dpt'][:since]
    last = summary['dpt'][:last]
    if since.nil?
      age_at_last = nil
    else
      age_at_last = age - (since/365) # This is age in years at the last dose
    end
    case count
      when 0
        next_dose = birth + 42  # first dose due at 6 weeks
      when 1..2
        next_dose = last + 28
      when 3
        next_dose = last + 183 # Six month interval to fourth dose -- is fourth dose given here? When, at 9 mo?
      when 4
        if age_at_last < 4  # "fourth dose not needed if third given at older than 4 years of age"
          next_dose = last + 183
          next_dose = birth + (365*4) if (next_dose < birth + 365*4) # fourth dose given at min 4 years old (check Nigeria policy**
        end
    end
    summary = update_next_dose(summary, 'dpt', next_dose)

    # After all the immunizations are assessed and next dose dates calculated
    return summary
  end

  def update_next_dose(summary, imm_type, next_dose)
    if next_dose
      next_dose = today if next_dose < today
      date_s = next_dose.to_s
      date_s = '*TODAY*' if next_dose == today
    else
      date_s = 'none'
    end
#    summary[imm_type].update({:next => next_dose, :next_s => date_s, :proc => 'yes'})   # Why :proc??
    summary[imm_type].update({:next => next_dose, :next_s => date_s})
    return summary
  end

  # ToDo: Move to the dates module or ?
  # How many months from a given date until today?
  def months_since(date)
    return (DateTime.now - date.to_datetime).to_i*(12/365.25)
  end

  def weeks_since(date)
    return (DateTime.now - date.to_datetime)/7.0
  end

  def days_since(date)
    return (DateTime.now - date.to_datetime).to_i
  end

  # This returns the *date* for today, as Date object, not DateTime. For matching with other Dates
  # ToDo: Move or eliminate
  def today
    t = DateTime.now
    return Date.new(t.year, t.month, t.day)
  end

end
