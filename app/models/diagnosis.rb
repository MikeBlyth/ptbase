# == Schema Information
#
# Table name: diagnoses
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  label       :string(255)
#  synonyms    :string(255)
#  comments    :string(255)
#  show_visits :boolean
#  sort_order  :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Diagnosis < ActiveRecord::Base
  attr_protected
  validates_presence_of :name

  def self.dx_visit_fields
    self.where(show_visits: true)
  end

  def self.dx_visit_names
    dx_visit_fields.map(&:name)
  end

  def self.dx_visit_prefixed_names
    dx_visit_fields.map {|dx| "dx_#{dx.name}"}
  end
end
