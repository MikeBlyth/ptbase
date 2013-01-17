# == Schema Information
#
# Table name: health_data
#
#  id         :integer          not null, primary key
#  patient_id :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rx_drug_list'

class HealthData < ActiveRecord::Base
  belongs_to :patient
  attr_protected

  # Has HIV concern if own status is positive OR (mother's status is positive and own is not Negative)
  def hiv?
    return hiv_status == 'positive' ||
        (hiv_pos_mother && hiv_status != 'negative')
  end

  def hiv_pos
    return hiv_status == 'positive'
  end

  def hiv_pos_mother # see hiv_pos;
    return self.maternal_hiv_status == 'positive'
  end

  def current_drugs
    recent_drugs(6).current
  end

  def current_drugs_formatted
    current_drugs.formatted
  end

private

  def recent_drugs(since=3)
    prescriptions = patient.prescriptions.confirmed.valid.where('date >= ?', Date.today-since.months)
    RxDrugList.new.add_prescriptions(prescriptions)
  end

end
