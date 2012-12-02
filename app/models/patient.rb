class Patient < ActiveRecord::Base
  attr_accessible :birth_date, :birth_date_exact, :death_date, :first_name, :ident, :last_name, :other_names, :sex
  validates_presence_of :last_name, :ident, :birth_date
  validates_uniqueness_of :ident
end
