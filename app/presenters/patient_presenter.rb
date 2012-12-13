class PatientPresenter
#  delegate :alive, to: :@patient

  def initialize(patient, template)
    @patient = patient
    @template = template
  end

  def alive_or_dead
    @patient.alive ? "alive (or no information on death)" :  "died on #{death_date}"
  end

  def photo_display(photo)
    if true || photo
      "<div style='min-width: 150px; min-height: 150px; border: 1px solid green'>Picture space</div>".html_safe
    end
  end

  def growth_chart
      "<div style='min-width: 150px; min-height: 150px; border: 1px solid green'>Growth chart</div>".html_safe
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
      result = <<-STATUS
        <tr><td class='med_info_label'>HIV status:</td>
        <td class='attention'>#{patient_status}
      STATUS
      result << " (mother is #{maternal_status})" if maternal_status
      result << "</td></tr>"
      result.html_safe!
    end
  end

  def show_latest_parameters(items=nil)
    latest = @patient.get_latest_parameters(items)
    result = ''
    # report the latest values of each of the parameters listed in the following array:
    items.each do |item|
      item_hash = latest[item]
      unless item_hash.nil? || item_hash[value].to_s.blank?
        %tr
        %td.med_info_label
        label = item_hash[:label]
        value = item_hash[:value]
        css_class = (label == 'Note') ? 'attention' : 'med_info_text'
        date = item_hash[:date]
        date_string = date.blank? ? '' : " on #{item_hash[:date]}"
        result << <<-ITEM_ROW
        <tr>
          <td class='med_info_label'>#{label}:</td>
          <td class='#{css_class}'>#{value}#{date_string} #{latest[:comments]}</td>
        </tr>
        ITEM_ROW
        result.html_safe!
      end
    end
  end

  def immunization_alerts
    # Flag as Hib needed in children under 5 years old with NO immunization record yet or if the record says the imm is needed
    if Immunization.hib_needed(@patient)
        "<tr><td class='med_info_label'>Note:</td><td class='attention'>Hib immunization needed</td></tr>".html_safe
    end
  end

  def anthropometric_summary
    latest = @patient.latest_parameters
    height, wt_pct, ht_pct, wt_for_ht_pct =
       [:height, :pct_expected_wt, :pct_expected_ht, :pct_expected_wt_for_ht].map {|item| latest[item][:value] }
    <<-ANTHRO
      <p class='anthro_summ'>Weight is #{wt_pct}% of expected for age.
      Height (#{height} cm) is #{ht_pct}% of expected for age.
      Weight is #{wt_for_ht_pct}% of expected for height.
      </p>
  ANTHRO
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

