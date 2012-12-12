module LabRequestHelper

  ##### FROM ORIGINAL APP
  #def tick_at (select_it, x, y, div_class ='lab_req_select', div_id='')
  #  return "" if (select_it.nil? || select_it == 0 || select_it == '')
  #  if select_it.class == String		#	if parameter passed is a string, print it, otherwise just print "X" if it's greater than one
  #    print_text = select_it
  #  else
  #    print_text = 'X'
  #  end
  #  offset_x = -0.4
  #  xscale = 11.7
  #  yscale = 9.07
  #  offset_y = 0
  #  yy = (y + offset_y)*yscale
  #  xx = (x + offset_x)*xscale
  #  s = "<div class='#{div_class}'  id='#{div_id}' style='position:absolute; top:#{yy}px; left:#{xx}px'%>" + print_text + "</div>"
  #  return s
  #end
  #
  #def text_at (text, x, y, div_class ='', div_id='')
  #  return "" if (text.nil? || text == 0 || text == '')
  #  offset_x = -0.4
  #  xscale = 11.7
  #  yscale = 9.07
  #  offset_y = 0
  #  yy = (y + offset_y)*yscale
  #  xx = (x + offset_x)*xscale
  #  s = "<div class='#{div_class}' id='#{div_id}' style='position:absolute; top:#{yy}px; left:#{xx}px'%>" +
  #      text + "</div>"
  #  return s
  #end


end