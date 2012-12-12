module PrescriptionItemsHelper

  # Copied from original application.rb. These do not need to be instance methods (they stand alone)
  def abbrev_to_interval(s)
    return $1 if s =~ /q([0-9]+\.?[0-9]*)h/   # if form 'q6h', 'q<number>h', $1 is the number of hours (decimal pt ok)
    interval  = {'stat' => 0,
                 'qd' => 24, 'od' => 24, 'daily' => 24,
                 'bd' => 12, 'bid' => 12,
                 'tds' => 8, 'tid' => 8,
                 'qds' => 6, 'qid' => 6
    }[s]    # note the [s] -- input string is key in hash to yield the value of hours
    raise ('Unrecognized drug frequency abbreviation: ' + s ) unless interval
    return interval
  end

  # Copied from original application.rb. These do not need to be instance methods (they stand alone)
  def interval_to_abbrev(i)
    raise "Non numeric drug interval: #{i}" unless i.belongs_to?(Numeric)
    a = case i
      when 1 then 'hourly'
      when 48 then 'every other day'
      when 24 then 'daily'
      when 0 then 'stat'
      else
        "q#{i}h"
    end
  end


end