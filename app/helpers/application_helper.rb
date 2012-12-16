module ApplicationHelper

  def present(object, klass=nil)
    klass ||= "#{object.class}Presenter".constantize
    presenter = klass.new(object, self)
    yield presenter if block_given?
    return presenter
  end

  def date_column(record, column)
    record.date.to_s(:default)
  end

  def concat_list(alist, delim=', ', end_delim='. ', str_if_empty='' )
    # given an array of values, concatenate their string representation separated by delim and ended with end_delim
    s = ''
    for list_item in alist
      list_item = str_if_empty if list_item.blank?  # allow use of a default value for missing data
      unless list_item.blank?   # do nothing for blank values
        s << delim unless s.blank?
        s << list_item.to_s
      end
    end
    s << end_delim if if s > '' # terminate with end_delim if s is not an empty string
                      end
    return s   # should automatically do this, but may as well make it explicit
  end

  def patient_name_link(patient)
    link_to "#{patient.name} [#{patient.ident}]", patient_path(patient)
 end

  # ToDo These should probably go into a presenter
  # The following methods logically should be in ptvisit_helper, but they're needed when the visit is
  # shown in other views such as the patient summary view. I don't see another way to refer to them
  # yet other than putting them here in the application helper.
  # Constants used in show_pe_findings -- eventually move the column list to a constant, too
  suppress_warnings do
    VARBASE = 'pe_'
    VSIZE = VARBASE.size
    SUFFIX = '_ok'
    SSIZE = SUFFIX.size
  end


  def show_pe_findings(model)
    columns = Visit.content_columns
    pe_columns = []
    # Get list of all the columns (variables) with form like 'pe_mouth', excluding the matching
    # items, 'pe_mouth_ok' etc. This gives a list of the elements in the physical exam
    for column in Visit.content_columns
      if (column.name.slice(0,VSIZE) == VARBASE) && (column.name.slice(-3,3) != SUFFIX)
        pe_columns << column.name.slice(VSIZE,column.name.size-VSIZE)
      end
    end
    # First, generate list of all the items which have some text.
    s = ''
    for column in pe_columns
      s << ' ' if s > ''
      finding = model.send(VARBASE+column)
      s << (column.capitalize) + ': ' + finding.to_s + '.' unless finding.blank?
    end
    s_findings = s
    s_normal = ''
    # Second, generate a list of items ticked as normal. This could be optional.
    normal_count = 0
    for column in pe_columns
      if (model.send(VARBASE+column+SUFFIX) || 0) == 1    # append the name if ticked
        s_normal << ', ' if s_normal > ''
        s_normal << column
        normal_count = normal_count + 1
      end
    end
    if s_normal > ''
      s_normal << ' all' if normal_count > 1  # just for style, to say 'mouth, eyes ... all normal'
      s_normal << ' normal.'
    end

    return s_findings + ' ' + s_normal.capitalize
  end

  # ToDo - Needs work (and tests)
  def show_val(value,
      str_if_empty='____',
      value_style='form_data',
      prefix='',
      suffix='',
      prefix_style='field_label')
    value_style = 'form_data' if value_style.blank?
    isblank = value.blank?
    if isblank && str_if_empty=='suppress'
      return ''
    end
    value = str_if_empty if isblank
    s = ''
    s << "<span class='#{prefix_style}'>" + prefix + "</span>" unless prefix.blank?
    s << "<span class='#{value_style}'>#{value}</span>"
    if (!isblank) && (!suffix.blank?) && (suffix != value.to_s[-1,1])
      s << suffix	#	Append suffix if it not already the last character in the string (e.g., avoids double periods)
    end
    return s.html_safe
  end

  def show_vars(model,varbase)
# Return a string listing all the columns in this set that are "true" e.g. checkboxes.
    s = ''
    delimiter = '; '
    for column in Visit.content_columns
      if column.name.slice(0,varbase.size) == varbase  && model.send(column.name) == 1
        s << delimiter if s > ''
        s << column.human_name.slice(varbase.size,99)
      end
    end
    return s
  end

  def table_field(params)
    item = params[:item]
    label = params[:label] || params[:item]
    html_options = params[:html_options]
    options = params[:options]
    label_tag item, label
    field = text_field(params[:record], item, html_options)
    content_tag(:td, cell_contents, class: 'field_label')
    #-#      %td.field_label
    #-#        %label{:for => "ptvisit_date"} Date
    #-#        %br/
    #-#        %input{:name => "ptvisit[date]", :size => "10", :type => "text", :value => @ptvisit.date.strftime("%d-%b-%Y") if not @ptvisit.date.nil?}
    #-#          %small
    #-#            %a{:href => "javascript:showCal('Calendar1')"} Calendar

  end

=begin      ################### From Original Application
    def authorized_as_admin
      #  Returns TRUE if the logged-in user has administrative privileges. How that is decided
      #  is determined by the logic here.
      if session[:user_id]  # is a user logged in?
        return User.find(session[:user_id]).priv_level > 100  # for now, this will be the sign
      end  # returns false if no user since that's the last calculated value (from the if clause)
    end

    def logged_user
      if session[:user_id]
        return User.find(session[:user_id]).name
      else
        return nil
      end
    end

    # write out today's date
    def today
      return Time.new.strftime("%d %b %Y")
    end

    def date_f(date)
      return date.to_s unless date.respond_to?('strftime')  # If the argument isn't really a date, just return its string representation
      s = date.strftime('%d-%b-%Y')
      s = s[1,s.size-1] if s[0,1] == '0'
      return s
    end

    def date_short(date)
      return '' if (date || '') == ''
      s = date.strftime('%d-%b')
      s = s[1,s.size-1] if s[0,1] == '0'
      return s
    end

    def interval_to_abbrev(i)
      case i
        when 1: 'hourly'
        when 48: 'every other day'
        when 24: 'daily'
        when 0: 'stat'
        when '': ''
        else
          "q#{i}h"
      end
    end

    def tooltip_in_link(some_text)
      return " \"return escape('#{some_text}')\" "
    end

    def my_tooltip(base_text,href,tip)
      return "<a href='#{href}' onmouseover=\"return escape('#{tip}')\">#{base_text}</a>"
    end

    def interval_abbrev(interval)    # another variation on interval_to_abbrev
      abbrev = {6 => 'qds (q6h)', 8 => 'tid', 12 => 'BD', 24 => 'daily', 0 => 'stat', '' => '', '&nbsp;' => '&nbsp;'}
      return abbrev[interval] || "q#{interval}h"
    end

    def concat_list(alist, delim=', ', end_delim='. ', str_if_empty='' )
      # given an array of values, concatenate their string representation separated by delim and ended with end_delim
      s = ''
      for list_item in alist
        list_item = str_if_empty if list_item.blank?  # allow use of a default value for missing data
        unless list_item.blank?   # do nothing for blank values
          s << delim unless s.blank?
          s << list_item.to_s
        end
      end
      s << end_delim if if s > '' # terminate with end_delim if s is not an empty string
                        end
      return s   # should automatically do this, but may as well make it explicit
    end

    def action_buttons(cancel_dest, submit_name='Save Changes', reset_name='Reset', cancel_name='Cancel')
# Generate a set of Save-Reset-Cancel buttons.
# NBs: IE apparently won't take the <a href=...><button ...> </button></a> form, appearing to ignore it completely, and
#      FF, inside a form, seems to assume that the default button type is 'submit', so we need to set it to 'button'
      s =
          "<input id='save_button' class='largebutton' name='commit' type='submit' value='#{submit_name}' />&nbsp;&nbsp;" +
              "<button id='reset_button' class='largebutton' type='reset'>#{reset_name}</button>&nbsp;&nbsp;" +
              %Q(<button id='cancel_button' type='button' class='largebutton' onClick='window.location="#{cancel_dest}"'>#{cancel_name}</button>)
      return s
    end

    def my_button(text, controller, id, action='new', bclass='add_new_button')
#Generate button code, doesn't use <form> as the button_for method does.
#%Q used for quoting so we can include single and double quotes in the string.
      url = url_for(:controller => controller, :action => action, :id => id)
      s = %Q(<button class='#{bclass}' type='button' onClick="window.location='#{url}'">#{text}</button>)
      return s
    end

    def save_button(submit_name='Save Changes')
      "<input id='save_button' class='largebutton' name='commit' type='submit' value='#{submit_name}' />"
    end

    def patient_name_link(patient)
      "<a href='/admin/show/#{patient.id}'> #{patient.name} [#{patient.hosp_ident}]</a>"
    end

  end

  # The following methods logically should be in ptvisit_helper, but they're needed when the visit is
  # shown in other views such as the patient summary view. I don't see another way to refer to them
  # yet other than putting them here in the application helper.
  # Constants used in show_pe_findings -- eventually move the column list to a constant, too
  VARBASE = 'pe_'
  VSIZE = VARBASE.size
  SUFFIX = '_ok'
  SSIZE = SUFFIX.size

  def show_pe_findings(model)
    columns = Visit.content_columns
    pe_columns = []
    # Get list of all the columns (variables) with form like 'pe_mouth', excluding the matching
    # items, 'pe_mouth_ok' etc. This gives a list of the elements in the physical exam
    for column in Visit.content_columns
      if (column.name.slice(0,VSIZE) == VARBASE) && (column.name.slice(-3,3) != SUFFIX)
        pe_columns << column.name.slice(VSIZE,column.name.size-VSIZE)
      end
    end
    # First, generate list of all the items which have some text.
    s = ''
    for column in pe_columns
      s << ' ' if s > ''
      finding = model.send(VARBASE+column)
      s << (column.capitalize) + ': ' + finding.to_s + '.' unless finding.blank?
    end
    s_findings = s
    s_normal = ''
    # Second, generate a list of items ticked as normal. This could be optional.
    normal_count = 0
    for column in pe_columns
      if (model.send(VARBASE+column+SUFFIX) || 0) == 1    # append the name if ticked
        s_normal << ', ' if s_normal > ''
        s_normal << column
        normal_count = normal_count + 1
      end
    end
    if s_normal > ''
      s_normal << ' all' if normal_count > 1  # just for style, to say 'mouth, eyes ... all normal'
      s_normal << ' normal.'
    end

    return s_findings + ' ' + s_normal.capitalize
  end

  def show_val(value,
      str_if_empty='____',
      value_style='form_data',
      prefix='',
      suffix='',
      prefix_style='field_label')
    value_style = 'form_data' if value_style.blank?
    isblank = value.blank?
    if isblank && str_if_empty=='suppress'
      return ''
    end
    value = str_if_empty if isblank
    s = ''
    s << "<span class='#{prefix_style}'>" + prefix + "</span>" unless prefix.blank?
    s << "<span class='#{value_style}'>#{value}</span>"
    if (!isblank) && (!suffix.blank?) && (suffix != value.to_s[-1,1])
      s << suffix	#	Append suffix if it not already the last character in the string (e.g., avoids double periods)
    end
    return s
  end


  def show_vars(model,varbase)
# Return a string listing all the columns in this set that are "true" e.g. checkboxes.
    s = ''
    delimiter = '; '
    for column in Visit.content_columns
      if column.name.slice(0,varbase.size) == varbase  && model.send(column.name) == 1
        s << delimiter if s > ''
        s << column.human_name.slice(varbase.size,99)
      end
    end
    return s
  end
=end

end
