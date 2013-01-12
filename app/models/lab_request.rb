# == Schema Information
#
# Table name: lab_requests
#
#  id          :integer          not null, primary key
#  provider_id :integer
#  patient_id  :integer
#  comments    :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#


class LabRequest < ActiveRecord::Base
  attr_accessible :date, :hct, :patient_id, :provider_id, :patient, :provider
  belongs_to :patient
  belongs_to :provider
  has_many :lab_results

end


LabResult.joins(:patient, :lab_request).
    where('patients.id = ?', 110).
    where('date(lab_requests.created_at) > ?', Date.today - 1.month).
    where(:lab_service_id => [43]).
    select('result, lab_service_id, date')

LabService.where("LOWER(lab_services.abbrev) IN ('cd4', 'cd4%')")

LabService.where(:abbrev => ['CD4'])