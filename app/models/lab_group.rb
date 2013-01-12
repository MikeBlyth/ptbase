# == Schema Information
#
# Table name: lab_groups
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  abbrev     :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class LabGroup < ActiveRecord::Base
  attr_accessible :abbrev, :name
  has_many :lab_services
end
