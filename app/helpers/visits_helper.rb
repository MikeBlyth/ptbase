require 'pry'
module VisitsHelper

  def diagnosis_check_boxes(dx_fields, dx_columns=4)
puts "diagnosis_check_boxes"
    dx_columns = 4
    dx_rows = ((dx_fields.size + dx_columns -1) / dx_columns).to_i   # how many rows
      table_contents = ''.html_safe
      0.upto(dx_rows-1) do |row|
          row_contents = ''.html_safe
          0.upto(dx_columns-1) do |column|
            dx_i = column*dx_rows + row # which diagnosis to put here
            dx_field = dx_fields[dx_i]
            unless dx_i >= dx_fields.size
                box = check_box :visit, dx_field.name
                label = label_tag :visit, dx_field.name
                row_contents << content_tag(:td, box+label)
            end
          end
        table_contents << content_tag(:tr, row_contents)
      end
    return content_tag(:table, table_contents)
  end

  def phys_finding(afield, alabel=afield.capitalize)

    s = "<td><label for='ptvisit_pe_#{afield}'>#{alabel}</label></td><td>" +
        check_box('ptvisit', "pe_"+afield+"_ok") +
        text_field('ptvisit', 'pe_'+afield, :size => 14) + "</td>"
    return s.html_safe
  end

  def phys_findings_column(items)
    s = "<td style='padding: 5px'><table>"
    for item in items
      s << '<tr>' + phys_finding(item) + '</tr>'
    end
    s << '</table></td>'
    return s.html_safe
  end

  # Not in use #########
  def  arv_check_box (arv_name, options={})
  	fieldname = "reg_" + arv_name
  	val = @visit.send(fieldname).to_i
  	s = check_box('ptvisit',fieldname, options) + "<label for='#{fieldname}'>#{arv_name}</label>"
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
#    s = "<td><label for='ptvisit_pe_#{afield}'>#{alabel}</label></td><td>" +
#        check_box('ptvisit', "pe_"+afield+"_ok") +
#        text_field('ptvisit', 'pe_'+afield, :size => 14) + "</td>"
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
#	val = @ptvisit.send(fieldname).to_i
#	s = check_box('ptvisit',fieldname, options) + "<label for='#{fieldname}'>#{arv_name}</label>"
#	return s
#  end
end