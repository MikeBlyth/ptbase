# == Schema Information
#
# Table name: icd9s
#
#  id          :integer          not null, primary key
#  icd9        :string(255)
#  mod         :string(255)
#  description :string(255)
#  short_descr :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Icd9 < ActiveRecord::Base
  attr_accessible :description, :icd9, :mod, :short_descr
end
