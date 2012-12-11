module NamesHelper

  def name
    initial = other_names.blank? ? '' : " #{other_names[0]}."
    return first_name+initial+ ' ' + last_name
  end

  def name_id
    return self.name + " [#{self.ident}]"
  end

  def name_last_first
    "#{last_name}, #{first_name}"
  end

  def name_last_first_id
    return self.name_last_first + " [#{self.ident}]"
  end

end