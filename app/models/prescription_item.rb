# == Schema Information
#
# Table name: prescription_items
#
#  id                 :integer          not null, primary key
#  drug               :string(255)
#  prescription_id    :integer
#  dose               :float
#  units              :string(255)
#  route              :string(255)
#  interval           :integer
#  use_liquid         :boolean
#  liquid             :integer
#  duration           :integer
#  other_description  :string(255)
#  other_instructions :string(255)
#  filled             :boolean
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

class PrescriptionItem < ActiveRecord::Base
  attr_accessible :dose, :drug, :duration, :filled, :interval, :liquid, :other_description, :other_instructions, :prescription_id, :route, :units, :use_liquid
end
