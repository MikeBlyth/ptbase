class Time

  def age_seconds
    (Time.now - self)
  end

  def age_days
    age_seconds/1.day
  end

  def age_hours
    age_seconds/1.hour
  end

  def age_months
    age_seconds/1.month
  end

  def age_weeks
    age_seconds/1.week
  end

  def age_years
    age_seconds/1.year
  end

  def age_human
    Time.time_human self.age_seconds
  end

  # Age in seconds
  def age_on_date(datetime)
    (datetime - self)
  end

  def age_on_date_in_years(datetime)
    age_on_date(datetime)/1.year
  end

  def age_on_date_human(datetime)
    return Time.time_human(age_on_date(datetime))
  end



  # return a string in days, weeks, months, or years, whatever makes sense for the age, from
  # time (t) in seconds. Sensible rounding is applied as we would normally describe someone's age.
  # Thus age_human(187000) = "2 days," age_human(34000000) = "12 months", age_human(120000000) = "3.8 years"
  # d, w, m, and y are day, week, month and year in seconds. Not efficient to calculate it each call, but
  # helps make clear what we're doing, and we can't define constants in a function
  def self.time_human(seconds, expand=true)
    return nil if seconds.nil?
    formatted = case
      when seconds < 48.hours
        value = (seconds/1.hour).floor
        "#{value} #{'hour'.pluralize(value)}"
      when (48.hours .. 1.month).include?(seconds)
        value = (seconds/1.day).floor
        "#{value} days"
      when (1.month .. 2.months).include?(seconds)
        value = (seconds/1.week).floor
         "#{value} #{'week'.pluralize value}"
      when (2.months .. 1.year).include?(seconds)
        value = (seconds/1.month).floor
        "#{value} months" + (sprintf(" (%0.2f year)", seconds/1.year) if expand)
      when (1.year .. 2.years).include?(seconds)
        value = (seconds/1.month).floor
        "#{value} months" + (sprintf(" (%0.1f years)", seconds/1.year) if expand)
      when (2.years .. 7.years).include?(seconds)
        sprintf("%1.1f years", seconds/1.year)
      else
        "#{(seconds/1.year).to_i} years"
    end
  end
end

class Object
  delegate :age_seconds, :age_hours, :age_days, :age_weeks, :age_years, :age_human,
           :age_on_date_in_years, :age_on_date, :age_on_date_human, :to => :date
end

class Date
# This lets Date use the same "age_xxx" methods as Time
  mods = %w(seconds hours days weeks years human on_date on_date_in_years on_date_human)

  mods.each do |mod|
    define_method "age_#{mod}" do
      self.to_time.send "age_#{mod}"
    end
  end

end

class DateTime
# This lets DateTime use the same "age_xxx" methods as Time
# One complication is that Ruby DateTime.to_time returns a DateTime rather than Time object,
# which is why we resort to Time.parse(self.to_s) to get a Time object
  mods = %w(seconds hours days weeks years human on_date on_date_in_years on_date_human)

  mods.each do |mod|
    define_method "age_#{mod}" do
      Time.parse(self.to_s).send "age_#{mod}"
    end
  end

end