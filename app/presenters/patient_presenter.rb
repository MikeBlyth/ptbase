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
end

