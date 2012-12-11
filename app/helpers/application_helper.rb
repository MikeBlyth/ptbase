module ApplicationHelper
  def date_column(record, column)
    record.date.to_s(:default)
  end

end
