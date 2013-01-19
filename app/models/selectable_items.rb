# Lists of symptoms, diagnoses, physical findings ... anything that just a simple name, label & checkbox can
# handle.
module SelectableItems
  #validates_presence_of :name
  #attr_accessible :name, :label, :synonyms, :comments, :show_visits, :sort_order

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def visit_fields
      self.where(show_visits: true)
    end

    def visit_names
      visit_fields.map(&:name)
    end

    def visit_tags
      visit_fields.map(&:to_tag)
    end
  end

  def to_label
    label || name.gsub('_',' ')
  end

  def to_tag
    name.downcase # prefix must be defined in the class including this module
  end

  def to_s
    name
  end

  def <=>(other)
    self.name <=> other.name
  end

end