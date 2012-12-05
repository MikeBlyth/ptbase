# == Schema Information
#
# Table name: photos
#
#  id           :integer          not null, primary key
#  patient_id   :integer
#  date         :datetime
#  comments     :string(255)
#  content_type :string(255)
#  name_string  :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Photo < ActiveRecord::Base
  include DateValidators
  attr_accessible :comments, :content_type, :date, :name_string, :patient_id, :patient
  belongs_to :patient
  validates_presence_of :patient_id, :date
  validate :not_future
end
