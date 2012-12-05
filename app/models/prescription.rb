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
  include DateValidators
  attr_accessible :confirmed, :date, :filled, :height, :prescriber_id, :prescriber, :voided, :weight,
                  :patient

  belongs_to :patient
  belongs_to :prescriber, class_name: 'Provider'
  has_many :prescription_items, :dependent=>:delete_all

  validates_presence_of :patient_id, :date, :prescriber_id
  validate :not_future
end
