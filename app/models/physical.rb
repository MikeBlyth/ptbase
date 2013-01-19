class Physical < ActiveRecord::Base
  include SelectableItems
  validates_presence_of :name
  attr_accessible :name, :label, :synonyms, :comments, :show_visits, :sort_order

  def prefix
    'pe_'
  end

end
