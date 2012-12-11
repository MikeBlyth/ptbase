class AdmissionsController < ApplicationController
  active_scaffold :admission do |config|
    config.list.columns = :patient, :date, :discharge_date, :diagnosis_1, :diagnosis_2, :meds, :discharge_status

  end

end
