module ImmunizationsHelper

  # Create hash like
  # {"DPT"=>[Mon, 29 Jan 2001 00:00:00 CET, Mon, 26 Feb 2001],
  #  "OPV"=>[Mon, 29 Jan 2001, Mon, 26 Feb 2001], 
  #  "BCG"=>[Mon, 08 Jan 2001]}
  # (Dates are all TimeWithZone objects)
  def imm_summary_hash(patient)
    imms = patient.immunizations.joins(:immunization_type).includes(:immunization_type).order(:sort_order, :date)
    imm_hash = Hash.new {|h,k| h[k] = []}
    imms.each {|imm| imm_hash[imm.abbrev] << imm.date }
    imm_hash
  end

  def imm_summary_table(patient)
    imm_hash = imm_summary_hash(patient)
    rows = []
    imm_hash.each do |imm, dates|
      cells = dates.map {|date| content_tag(:td, date.to_s(:date_short).html_safe)}
      imm_name = content_tag(:td, imm.html_safe)
      rows << content_tag(:tr, imm_name + cells.join.html_safe)
    end
    return content_tag(:table, rows.join.html_safe, class: 'imm_table').html_safe
  end
end