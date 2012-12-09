class RxDrugList < Hash
  def initialize(hash={})
    hash.each {|k,v| self[k]=v}
  end

  def add_item(new_item)
    return false if new_item.nil?
    drug = new_item[:drug]
    ex = self[drug]
    return false if (self.include? drug) && (self[drug].date > new_item.date)
    self[drug] = new_item
    return self
  end

  def add_prescriptions(prescriptions={})
    return false if prescriptions.empty?
    prescriptions.each do |rx|
      rx.items.each {|item| self.add_item(item)}
    end
  end

  def current
    RxDrugList.new(self.select {|k,v| v.current?})
  end

  def formatted
    self.map do |drug, item|
      "#{drug} #{item[:dose]} #{item[:units]} #{item[:route]} q#{item[:interval]}h x #{item[:duration]} days."
    end
  end
end
