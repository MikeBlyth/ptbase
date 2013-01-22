# == Schema Information
#
# Table name: symptoms
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  label        :string(255)
#  synonyms     :string(255)
#  comments     :string(255)
#  show_visits  :boolean
#  sort_order   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  with_comment :boolean
#

require 'selectable_items'
class Symptom < ActiveRecord::Base
  include SelectableItems
  validates_presence_of :name
  attr_accessible :name, :label, :synonyms, :comments, :show_visits, :sort_order, :with_comment
end
