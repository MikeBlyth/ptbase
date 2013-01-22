require 'pry'
module VisitsHelper

  def section_check_boxes(section, columns=4)  # section is Class name for table to use e.g., Symptom
    fields = section.visit_fields
    return nil if fields.empty?
    rows = ((fields.length + columns -1) / columns).to_i   # how many rows
    table_contents = ''.html_safe
    0.upto(rows-1) do |row|
      row_contents = ''.html_safe
      0.upto(columns-1) do |column|
        i = column*rows + row # which diagnosis to put here
        field = fields[i]
        unless i >= fields.count
          box = check_box :visit, field.to_tag
          label = label_tag :visit, field.to_label
          row_contents << content_tag(:td, box+label)
        end
      end
      table_contents << content_tag(:tr, row_contents)
    end
    return content_tag(:table, table_contents)
  end

  # To DISPLAY the diagnoses selected for this visit
  def show_diagnoses(visit)
    diagnoses = ([visit.dx, visit.dx2, selections_to_string(visit, :diagnoses)]).join('; ')
    return diagnoses.blank? ? nil : diagnoses + '.'
  end

  def show_symptoms(visit)
    selections_to_string(visit, :symptoms)
  end

  def show_exam(visit)
    normal, noted = selectable_selected(visit, :physical).partition {|x| ['', 'normal'].include? x[1]}
    noted_str = noted.any? ? noted.map{|x| "#{x[0]}: #{x[1]}"}.join('; ') + '. ' : ''
    normal_str = normal.any? ? [normal.map {|x| x[0]}.join(', '), all_both(normal.size), 'normal.'].join(' ') : ''
    return noted_str + normal_str.capitalize
  end

  def hiv_status_summary(visit)
    para = []
    para << "HIV stage #{visit.hiv_stage || 'not noted'}"
    para << "ARV status: #{Visit.arv_statuses[visit.arv_status] || visit.arv_status || 'not noted'}"
    regimen = visit.arv_reg_str
    para << "ARV regimen: #{regimen}" if regimen
    assessment_choices = %w(stable drug_toxicity opportunistic_infection non_adherence).map do |status|
      visit.send("assessment_#{status}") ? status.spacerize : nil
    end.compact.join('; ').capitalize
    para <<  assessment_choices if  assessment_choices
    return para.join('. ') +'.'
  end

  def visit_labs(visit)
    visit.patient.lab_results.where(:date => (visit.date-4.hours)..(visit.date+24.hours)).
        map {|lab| "#{lab.lab_service.abbrev}: #{lab.result}"}.join("; ")
  end

  def visit_drugs(visit)
    visit.patient.prescriptions.where(:date => (visit.date)..(visit.date+24.hours)).map do |prescription|
        prescription.prescription_items.map do |item|
          "#{item.drug} #{item.dose} #{item.route} q#{item.interval} hr x #{item.duration} days."
        end
    end.join("; ")

  end

  def all_both(n)
    case n
      when 0, 1 then nil
      when 2 then 'both'
      else 'all'
    end
  end

  # Not in use #########
  def  arv_check_box (arv_name, options={})
  	fieldname = "reg_" + arv_name
  	val = @visit.send(fieldname).to_i
  	s = check_box('visit',fieldname, options) + "<label for='#{fieldname}'>#{arv_name}</label>"
  	return s
  end


  ### FROM ORIGINAL APP
#  def bubble_show(label, value, style)
#    if value == true || value == 1
#		pic = '/images/box-checked.png'
#	else
#		pic = '/images/box-empty.png'
#	end
#	s = "<img src='#{pic}' height='13'>&nbsp;<span class='form_small'>#{label}</span>"
#  end

#  def bubble_empty
#	s = "<img src='/images/box-empty.png' height='13'>"
#  end

#  def phys_finding(afield, alabel=afield.capitalize)
#
#    s = "<td><label for='visit_pe_#{afield}'>#{alabel}</label></td><td>" +
#        check_box('visit', "pe_"+afield+"_ok") +
#        text_field('visit', 'pe_'+afield, :size => 14) + "</td>"
#  end

#  def phys_findings_column(items)
#    s = "<td style='padding: 5px'><table>"
#    for item in items
#      s << '<tr>' + phys_finding(item) + '</tr>'
#    end
#    s << '</table></td>'
#  end



#  def  arv_check_box (arv_name, options={})
#	fieldname = "reg_" + arv_name
#	val = @visit.send(fieldname).to_i
#	s = check_box('visit',fieldname, options) + "<label for='#{fieldname}'>#{arv_name}</label>"
#	return s
#  end
end
