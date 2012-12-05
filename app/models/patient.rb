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

  #  has_many :visits, :labs, :admissions, :immunizations, :photos, :prescriptions, dependent: :delete
  attr_accessible :birth_date, :birth_date_exact, :death_date, :first_name, :ident, :last_name, :other_names, :sex
  validates_presence_of :last_name, :ident, :birth_date
  validates_uniqueness_of :ident
  validate :valid_birth_date

  def name
    initial = other_names.blank? ? '' : " #{other_names[0]}."
    return first_name+initial+ ' ' + last_name
  end

end
