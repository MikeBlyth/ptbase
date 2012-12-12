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
  attr_accessible :patient, :date, :bed, :comments, :diagnosis_1, :diagnosis_2,
                  :discharge_date, :discharge_status, :meds, :ward, :weight_admission, :weight_discharge
  belongs_to :patient
  belongs_to :provider
  validates_presence_of :date, :diagnosis_1, :patient_id
  validate :not_future
  validate :validate_all

  def to_label
    date
  end

protected

  def validate_all

    min_date = Date.new(1990,1,1)
    max_date = DateTime.now()
    errors.add(:weight_admission, "should be from 0 to 250 kg") unless weight_admission.nil? || weight_admission.between?(0, 250)
    errors.add(:weight_discharge, "should be from 0 to 250 kg") unless weight_discharge.nil? || weight_discharge.between?(0, 250)
    errors.add(:discharge_date, "cannot be earlier than admission date") if !discharge_date.nil? && discharge_date < date
    errors.add(:discharge_date, "cannot be in the future") if !discharge_date.nil? && !discharge_date.between?(min_date, max_date)
    errors.add(:date, "invalid") if !date.nil? && !date.between?(min_date, max_date)
    errors.add(:diagnosis_1, " (First diagnosis) required at discharge") if (discharge_date || '') != '' && (diagnosis_1 || '') == ''
    errors.add(:discharge_status, "cannot be 'On Adm' after discharge") if (discharge_date || '') != '' && discharge_status == 'On Adm'

  end

end
