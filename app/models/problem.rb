# == Schema Information
#
# Table name: problems
#
#  id          :integer          not null, primary key
#  description :string(255)
#  date        :datetime
#  resolved    :datetime
#  patient_id  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Problem < ActiveRecord::Base
  include DateValidators
  attr_accessible :date, :description, :patient_id, :resolved, :patient
  belongs_to :patient
  validate :not_future
  validate :resolved_not_future
  validates_presence_of :date, :description, :patient_id

  def resolved_not_future
    errors.add(:resolved, 'cannot be in the future') if resolved && (resolved > DateTime.now)
  end


end
