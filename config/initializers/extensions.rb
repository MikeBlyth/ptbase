class ActiveRecord::Base
  def self.latest(sortfield='date')
    self.order("#{sortfield} DESC").first
  end
end