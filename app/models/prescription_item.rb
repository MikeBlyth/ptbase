# == Schema Information
#
# Table name: prescription_items
#
#  id                 :integer          not null, primary key
#  drug               :string(255)
#  prescription_id    :integer
#  dose               :float
#  units              :string(255)
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
                  :other_description, :other_instructions, :route, :units, :use_liquid
  belongs_to :prescription
  validates_presence_of :drug, :prescription_id
  delegate :date, :patient, :confirmed, :void, :filled, to: :prescription

  def current?
    date + duration.days >= Date.today
  end
end
