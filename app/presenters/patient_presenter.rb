class PatientPresenter

  def initialize(patient, template)
    @patient = patient
    @template = template
  end
  attr_accessor :patient
  delegate :content_tag, :to => :@template

  def alive_or_dead
    @patient.alive ? "alive (or no information on death)" :  "died on #{@patient.death_date}"
  end

  def photo_display(photo)
    if true || photo
      "<div style='min-width: 150px; min-height: 150px; border: 1px solid green'>Picture space</div>".html_safe
    end
  end

  def growth_chart
      "<div style='min-width: 250px; min-height: 250px; border: 1px solid green'>Growth chart</div>".html_safe
  end

  #ToDo need inplace edit field here!
  def comments
    if  @patient.comments.blank?
      to_show = '[Add comment] {need inplace edit field here!}'
      tag = "<td id='attn'>"
    else
      to_show =  @patient.comments
      tag = "<td id='attn', class='attention'>"
    end
    return "#{tag}#{to_show}</td>".html_safe
  end

  def allergies
    unless @patient.allergies.blank?
      "<tr><td class='med_info_label'>Allergies:</td><td class='attention'>#{@patient.allergies}</td></tr>".html_safe
    end
  end

  def hemoglobin_type
    hb_type = @patient.hemoglobin_type
    unless hb_type.blank?
      css_class = (hb_type.upcase == 'SS') ? 'attention' : ''
      "<tr><td class='med_info_label'>Hb type:</td><td class='#{css_class}'>#{hb_type}</td></tr>".html_safe
    end
  end

  def hiv_status
    maternal_status = @patient.maternal_hiv_status
    patient_status = @patient.hiv_status
    if patient_status || maternal_status
      css_class = (patient_status == 'positive' || maternal_status == 'positive' ) ? 'attention' : ''
      result = <<-STATUS
        <tr><td class='med_info_label'>HIV status:</td>
        <td class='#{css_class}'>#{patient_status}
      STATUS
      result << " (mother is #{maternal_status})" if maternal_status
      result << "</td></tr>"
      result.html_safe
    end
  end

  def show_latest_parameters(*items)
    items ||= [:hct, :cd4, :weight]
    latest = @patient.latest_parameters(items)
    result = ''
    # report the latest values of each of the parameters listed in the following array:
    items.each do |item|
      item_hash = latest[item]
      unless item_hash.nil? || item_hash[:value].to_s.blank?
        label = item_hash[:label]
        value_span = content_tag(:span, item_hash[:value], class: 'item_value').html_safe

        comments = item_hash[:comment]
        if comments.blank?
          comments_span = ''
        else
          comments_span = content_tag(:span, item_hash[:comment], class: 'item_comment')
        end

        css_class = (label == 'Note') ? 'attention' : 'med_info_text'

        date = item_hash[:date]
        if date.blank?
          date_span = ''
        else
          date_span = ' on '.html_safe + content_tag(:span,date, class: 'item_date')
        end

        label_cell = content_tag('td', label + ":", class: 'med_info_label')
        value_cell = content_tag('td', value_span+date_span+comments_span, class: css_class)
        row_cell = content_tag('tr', label_cell+value_cell)
        result << row_cell + "\n"  # The \n is just for readability in HTML output
      end
    end
#puts "show_latest_parameters returning #{result.html_safe}"
    return result.html_safe
  end

  def immunization_alerts
    # Flag as Hib needed in children under 5 years old with NO immunization record yet or if the record says the imm is needed
    if Immunization.hib_needed(@patient)
      label = content_tag(:td, 'Note:', class: 'attention')
      note = content_tag(:td, "Hib immunization needed", class: 'attention')
      content_tag(:tr, label+note, class: 'note_row' )
    end
  end

  def anthropometric_summary
    latest = @patient.latest_parameters.add_anthropometrics
    height, wt_pct, ht_pct, wt_for_ht_pct =
       [:height, :pct_expected_wt, :pct_expected_ht, :pct_expected_wt_for_ht].map {|item| latest[item][:value] }
    results = <<-ANTHRO
      Weight is #{wt_pct}% of expected for age.
      Height (#{height} cm) is #{ht_pct}% of expected for age.
      Weight is #{wt_for_ht_pct}% of expected for height.
  ANTHRO
    return content_tag(:p, results, class: 'anthro_summ')
  end

  def begin_stop_course(params)
    course = params[:course]
    label = params[:label]
    began = @patient.send "#{course}_begin"
    ended = @patient.send "#{course}_stop"
    return nil unless began || ended
    began_str = began ? "Began #{label} #{began}" : "Began #{label} -- when?"
    end_str = ended ? ", stopped #{ended}." : '.'
    "#{began_str}#{end_str}".html_safe
  end

private

end

