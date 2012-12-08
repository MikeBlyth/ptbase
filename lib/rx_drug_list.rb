class RxDrugList < Hash
  def initialize
  end

  def add_item(new_item)
    drug = new_item[:drug]
    return false if (self.include? drug) && (self[drug][:date] > new_item.date)
    self[drug] = new_item
  end
end