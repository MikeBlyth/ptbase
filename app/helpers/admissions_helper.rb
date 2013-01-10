module AdmissionsHelper
  def discharge_statuses
    %w(recovered improved AMA still_ill transferred died unknown)
  end

  def discharge_date_column(record, column)
    record.discharge_date.to_s
  end

end