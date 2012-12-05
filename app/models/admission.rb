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
#  admission_date   :datetime
#  discharge_date   :datetime
#  discharge_status :string(255)
#  comments         :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Admission < ActiveRecord::Base
  attr_accessible :admission_date, :bed, :comments, :diagnosis_1, :diagnosis_2, :discharge_date, :discharge_status, :meds, :patient_id, :ward, :weight_admission, :weight_discharge
end
