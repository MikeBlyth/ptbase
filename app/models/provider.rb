class Provider < ActiveRecord::Base
  attr_accessible :first_name, :ident, :last_name, :other_names
  validates_presence_of :first_name, :last_name
  has_many :visits
  has_many :labs
  has_many :admissions
  has_many :immunizations
  has_many :prescriptions
end
