module VisitsHelper
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