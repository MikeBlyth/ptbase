# == Schema Information
#
# Table name: prescription_items
#
#  id                 :integer          not null, primary key
#  drug               :string(255)
#  prescription_id    :integer
#  dose               :string(255)
#  unit               :string(255)
#  route              :string(255)
#  interval           :integer
#  use_liquid         :boolean
#  liquid             :integer
#  duration           :integer
#  other_description  :string(255)
#  other_instructions :string(255)
#  filled             :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'forwardable'

class PrescriptionItem < ActiveRecord::Base
  attr_accessible :dose, :drug, :duration, :filled, :interval, :liquid, :prescription, :prescription_id,
                  :other_description, :other_instructions, :route, :unit, :use_liquid
  belongs_to :prescription
  validates_presence_of :drug, :interval, :duration #, :prescription_id
  validate :valid_interval
  delegate :date, :patient, :confirmed, :void, :filled, to: :prescription

  def to_label
    drug
  end

  def to_s
    drug
  end

  def current?
    date + duration.days >= Date.today
  end

  def valid_interval
    unless [0,1,2,3,4,6,8,12,18,24,36,48].include?(interval)
      errors.add(:interval,"Dosing interval of #{interval} hours is not allowed")
    end
  end

end
