class ImmunizationType < ActiveRecord::Base
  attr_accessible :abbrev, :name, :notes

  has_many :immunizations
  validates_presence_of :abbrev, :name
end
