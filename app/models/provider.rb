class Provider < ActiveRecord::Base
  attr_accessible :first_name, :ident, :last_name, :other_names
  validates_presence_of :first_name, :last_name
end
