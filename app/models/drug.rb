# == Schema Information
#
# Table name: drugs
#
#  id         :integer          not null, primary key
#  item       :string(255)
#  class      :string(255)
#  subclass   :string(255)
#  synonyms   :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Drug < ActiveRecord::Base
  attr_protected

end
