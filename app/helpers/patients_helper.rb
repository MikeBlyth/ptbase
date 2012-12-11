module PatientsHelper

  def birth_date_column(record, column)
    record.birth_date.to_s(:default)
  end

end