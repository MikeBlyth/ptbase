# == Schema Information
#
# Table name: drugs
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  drug_class    :string(255)
#  drug_subclass :string(255)
#  synonyms      :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Drug < ActiveRecord::Base
  attr_protected
  has_many :drug_preps
  validates_presence_of :name
  validates_uniqueness_of :name

  def to_s
    name
  end
end
