# == Schema Information
#
# Table name: prescriptions
#
#  id            :integer          not null, primary key
#  patient_id    :integer
#  prescriber_id :integer
#  date          :datetime
#  filled        :boolean
#  confirmed     :boolean
#  voided        :boolean
#  weight        :float
#  height        :float
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Prescription < ActiveRecord::Base
  attr_accessible :confirmed, :date, :filled, :height, :patient_id, :prescriber_id, :voided, :weight
end
