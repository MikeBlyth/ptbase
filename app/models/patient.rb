# == Schema Information
#
# Table name: patients
#
#  id               :integer          not null, primary key
#  first_name       :string(255)
#  last_name        :string(255)
#  other_names      :string(255)
#  birth_date       :date
#  death_date       :date
#  birth_date_exact :boolean
#  ident            :string(255)
#  sex              :string(255)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Patient < ActiveRecord::Base
  include DateValidators

  has_many :visits, dependent: :delete_all
  has_many :labs, dependent: :delete_all
  has_many :admissions, dependent: :delete_all
  has_many :immunizations, dependent: :delete_all
  has_many :prescriptions, dependent: :delete_all
  has_many :photos, dependent: :delete_all
  has_many :visits, dependent: :delete_all
  attr_accessible :birth_date, :birth_date_exact, :death_date, :first_name, :ident, :last_name, :other_names,
                  :sex
  validates_presence_of :last_name, :ident, :birth_date
  validates_uniqueness_of :ident
  validate :valid_birth_date

  def name
    initial = other_names.blank? ? '' : " #{other_names[0]}."
    return first_name+initial+ ' ' + last_name
  end

  def name_id
    return self.name + " [#{self.ident}]"
  end

  def name_last_first
    "#{last_name}, #{first_name}"
  end

  def name_last_first_id
    return self.name_last_first + " [#{self.ident}]"
  end

end
