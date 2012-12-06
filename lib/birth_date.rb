#module BirthDate
#  class BirthDate
#    # To change this template use File | Settings | File Templates.
#    attr_reader :datetime
#    def initialize(*datetime)
#      @datetime = DateTime.new(*datetime)
#    end
#
#    def age
#      (DateTime.now-@date).in_days
#    end
#  end
#end

class DateTime
  SECONDS_PER_YEAR = 3600*24*365.25
  SECONDS_PER_DAY = 3600*24

  def age_seconds
    (DateTime.now - self).to_f*SECONDS_PER_DAY
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
    DateTime.time_human self.age_seconds
  end

  # Age in seconds
  def age_on_date(datetime)
    (datetime - self)*SECONDS_PER_DAY.to_i
  end

  def age_on_date_in_years(datetime)
    age_on_date(datetime)/1.year
  end

  def age_on_date_human(datetime)
    return DateTime.time_human(age_on_date(datetime))
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