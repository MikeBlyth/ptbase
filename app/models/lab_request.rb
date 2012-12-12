# == Schema Information
#
# Table name: lab_requests
#
#  id            :integer          not null, primary key
#  patient_id    :integer
#  date          :datetime
#  hct           :boolean
#  fbc           :boolean
#  malaria       :boolean
#  hiv_rapid     :boolean
#  urinalysis    :boolean
#  blood_glucose :boolean
#  cd4           :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

# ToDo - Whole thing needs to be reworked
class LabRequest < ActiveRecord::Base
  attr_accessible :date, :hct, :patient_id, :provider_id
  belongs_to :patient
  belongs_to :provider
end
