# == Schema Information
#
# Table name: admissions
#
#  id               :integer          not null, primary key
#  patient_id       :integer
#  bed              :string(255)
#  ward             :string(255)
#  diagnosis_1      :string(255)
#  diagnosis_2      :string(255)
#  meds             :string(255)
#  weight_admission :float
#  weight_discharge :float
#  date             :datetime
#  discharge_date   :datetime
#  discharge_status :string(255)
#  comments         :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  provider_id      :integer
#

class Admission < ActiveRecord::Base
  include DateValidators
  attr_accessible :date, :bed, :comments, :diagnosis_1, :diagnosis_2, :discharge_date, :discharge_status, :meds, :ward, :weight_admission, :weight_discharge
  belongs_to :patient
  belongs_to :provider
  validates_presence_of :date, :diagnosis_1, :patient_id
  validate :not_future
end
