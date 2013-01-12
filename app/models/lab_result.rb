# == Schema Information
#
# Table name: lab_results
#
#  id             :integer          not null, primary key
#  lab_request_id :integer
#  lab_service_id :integer
#  result         :string(255)
#  date           :datetime
#  status         :string(255)
#  abnormal       :boolean
#  panic          :boolean
#  comments       :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class LabResult < ActiveRecord::Base
  attr_accessible :comments, :lab_request_id, :result, :date
  belongs_to :lab_request
  belongs_to :lab_service
end
