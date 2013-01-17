module PatientsHelper

  def birth_date_column(record, column)
    record.birth_date.to_s(:default)
  end

  def birth_date2(record)
    record.birth_date.to_date
  end
end