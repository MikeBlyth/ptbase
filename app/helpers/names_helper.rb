module NamesHelper

  def name
    initial = middle_name.blank? ? '' : " #{middle_name[0]}."
    return (first_name || '') + initial + ' ' + (last_name || '')
  end

  def with_title(a_name)
    (self.respond_to? :title) && self.title.present? ? "#{title} #{a_name}" : a_name
  end

  def with_degree(a_name)
    (self.respond_to? :degree) && self.degree.present? ? "#{a_name}, #{degree}" : a_name
  end

  def name_last_first
    "#{last_name}, #{first_name}"
  end

  def name_last_first_id
    return self.name_last_first + " [#{self.ident}]"
  end

end