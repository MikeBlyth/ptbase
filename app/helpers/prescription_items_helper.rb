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

  def formatted_prescription_item(p)
    "#{p.drug} #{p.dose} #{p.unit} #{p.route} every #{p.interval} hours for #{p.duration} days."
  end


  def single_line_form(item, index)
    item_id = item.id || "New#{index}"
    id_base = "prescription_item_#{item_id}"
    content_tag(:div,
      (content_tag(:span, "#{index}", class: "rx_item_num") +
        rx_field(item, item_id, 'drug', id_base) +
        rx_field(item, item_id, 'dose', id_base) +
        rx_field(item, item_id, 'unit', id_base) +
        rx_field(item, item_id, 'route', id_base) +
        rx_field(item, item_id, 'interval', id_base) +
        rx_field(item, item_id, 'duration', id_base) +
        rx_field(item, item_id, 'other_instructions', id_base)
      ),
      id: "#{id_base}")

  end

private

  def rx_field(item, item_id, field, id_base)
    name_base =  "prescription[prescription_items][#{item_id}]"
    z = simple_fields_for item do |f|
      f.input field, input_html: {id: "#{id_base}_#{field}", name: "#{name_base}[#{field}]"}
    end
    puts z
    z
  end

end

#<input id="prescription_item_dose" class="numeric float optional" type="number" step="any" name="prescription_item[dose]">