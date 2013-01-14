class ActiveRecord::Base
  def self.latest(sortfield='date')
    self.order("#{sortfield} DESC").first
  end

  # Update record with an attribute-value hash, but ignore attributes that do not belong
  # to the record.
  def set_attrs_soft(new_attrs)
    updatable = new_attrs.select {|k,v| self.class.column_names.include? k.to_s}
    updatable.each {|k,v| puts "self.send '#{k}=', #{v}"; self.send "#{k}=", v}
    return self
  end
end

class String
  def any?
    not blank?
  end

  def to_f_if_numeric
    Float(self) rescue self
  end
end

class NilClass
  def any?
    false
  end

  def to_s(options=nil)
    ''
  end

  def empty?
    true
  end
end

