# == Schema Information
#
# Table name: health_data
#
#  id                  :integer          not null, primary key
#  patient_id          :integer
#  hiv_status          :string(255)
#  maternal_hiv_status :string(255)
#  allergies           :string(255)
#  comments            :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class HealthData < ActiveRecord::Base
  belongs_to :patient
end
