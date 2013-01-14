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
  include NamesHelper
  attr_accessible :first_name, :ident, :last_name, :other_names

  validates_presence_of :first_name, :last_name
  has_many :visits
  has_many :admissions
  has_many :immunizations
  has_many :prescriptions

  def to_s
    name_id
  end

  def name_id
    "#{last_name}, #{first_name} [#{ident}]"
  end

end
