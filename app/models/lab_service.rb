# == Schema Information
#
# Table name: lab_services
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  abbrev       :string(255)
#  unit         :string(255)
#  normal_range :string(255)
#  lab_group_id :integer
#  cost         :float
#  comments     :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class LabService < ActiveRecord::Base
  attr_accessible :abbrev, :comments, :cost, :name, :lab_group, :lab_group_id
  belongs_to :lab_group
  has_many :lab_results
  validates_presence_of :name, :abbrev
end
