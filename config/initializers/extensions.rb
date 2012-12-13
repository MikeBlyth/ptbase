class ActiveRecord::Base
  def self.latest(sortfield='date')
    self.order("#{sortfield} DESC").first
  end
end

class String
  def any?
    not blank?
  end
end

class NilClass
  def any?
    not blank?
  end
end