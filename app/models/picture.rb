# == Schema Information
#
# Table name: pictures
#
#  id           :integer          not null, primary key
#  patient_id   :integer
#  comment      :string(255)
#  name         :string(255)
#  content_type :string(255)
#  date         :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Picture < ActiveRecord::Base
  attr_accessible :comment, :content_type, :date, :name, :patient_id
end
