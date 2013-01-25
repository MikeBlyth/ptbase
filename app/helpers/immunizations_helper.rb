module ImmunizationsHelper

  def imm_table(patient)
    imms = patient.immunizations.includes(:immunization_type).order(:immunization_type_id, :date)
    dates = imms.map{|i| i.date}.uniq.sort
    imm_types = imms.map{|i| i.abbrev}.uniq

  end

end