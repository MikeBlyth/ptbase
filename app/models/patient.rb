class Patient < ActiveRecord::Base
  has_many :visits
  attr_accessible :birth_date, :birth_date_exact, :death_date, :first_name, :ident, :last_name, :other_names, :sex
  validates_presence_of :last_name, :ident, :birth_date
  validates_uniqueness_of :ident
  validate :birth_date_past

  def name
    initial = other_names.blank? ? '' : " #{other_names[0]}."
    return first_name+initial+ ' ' + last_name
  end

private
  def birth_date_past
    errors.add(:birth_date, 'cannot be in the future') if birth_date && (birth_date >= DateTime.now)
  end
end
