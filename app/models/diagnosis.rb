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

  def to_label
    label || name.gsub('_',' ')
  end

  def to_tag
    "dx_#{name.downcase}"
  end

  def to_s
    name
  end

  def self.dx_visit_fields
    self.where(show_visits: true)
  end

  def self.dx_visit_names
    dx_visit_fields.map(&:name)
  end

  def self.dx_visit_tags
    dx_visit_fields.map(&:to_tag).keep_if{|dx| Visit.column_names.include? dx}
      # ToDO -- the "keep if" won't be necessary when Visit is changed to be able to handle arbitrary diagnoses
  end

  def <=>(other)
    self.name <=> other.name
  end
end
