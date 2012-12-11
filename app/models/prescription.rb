# == Schema Information
#
# Table name: prescriptions
#
#  id          :integer          not null, primary key
#  patient_id  :integer
#  provider_id :integer
#  date        :datetime
#  filled      :boolean
#  confirmed   :boolean
#  void        :boolean
#  weight      :float
#  height      :float
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Prescription < ActiveRecord::Base
  include DateValidators
  attr_accessible :confirmed, :date, :filled, :height, :provider_id, :provider, :void, :weight,
                  :patient

  belongs_to :patient
  belongs_to :provider
  has_many :prescription_items, :dependent=>:delete_all

  validates_presence_of :patient_id, :date, :provider_id
  validate :not_future

  def to_label
    date
  end

  def self.valid
    self.where("void IS ? OR NOT void",nil)
  end

  def self.confirmed
    self.where(:confirmed=>true)
  end

  def items
    self.prescription_items
  end
end
