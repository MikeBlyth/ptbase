module DateValidators
  def not_future
    errors.add(:date, 'cannot be in the future') if date && (date > DateTime.now)
  end

  def valid_birth_date
puts "birth_date=#{birth_date}, #{birth_date.class}"
    errors.add(:birth_date, 'cannot be in the future') if birth_date && (birth_date > DateTime.now)
    errors.add(:birth_date, 'makes person too old') if birth_date && (birth_date < DateTime.now - 120.years)
  end

end
