# == Schema Information
#
# Table name: physicals
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  label       :string(255)
#  synonyms    :string(255)
#  comments    :string(255)
#  sort_order  :integer
#  show_visits :boolean
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Physical < ActiveRecord::Base
  include SelectableItems
  validates_presence_of :name
  attr_accessible :name, :label, :synonyms, :comments, :show_visits, :sort_order, :with_comment

end
