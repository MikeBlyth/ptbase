# == Schema Information
#
# Table name: lab_requests
#
#  id          :integer          not null, primary key
#  provider_id :integer
#  patient_id  :integer
#  comments    :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#


class LabRequest < ActiveRecord::Base
  attr_accessible :date, :hct, :patient_id, :provider_id, :patient, :provider, :lab_results_attributes
  belongs_to :patient
  belongs_to :provider
  has_many :lab_results
  validates_presence_of :provider_id, :patient_id
  before_validation :default_date
  accepts_nested_attributes_for :lab_results

  def to_s
    "Lab requests for #{patient}, #{date}"
  end

  private
  def default_date
    self.date ||= DateTime.now
  end
end

