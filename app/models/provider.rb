# == Schema Information
#
# Table name: providers
#
#  id          :integer          not null, primary key
#  last_name   :string(255)
#  first_name  :string(255)
#  other_names :string(255)
#  ident       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Provider < ActiveRecord::Base
  attr_accessible :first_name, :ident, :last_name, :other_names
  validates_presence_of :first_name, :last_name
  has_many :visits
  has_many :labs
  has_many :admissions
  has_many :immunizations
  has_many :prescriptions
end
