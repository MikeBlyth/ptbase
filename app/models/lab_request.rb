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
  attr_accessible :date, :hct, :patient_id, :provider_id
  belongs_to :patient
  belongs_to :provider
  has_many :lab_results

end
