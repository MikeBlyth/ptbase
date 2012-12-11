class LabsController < ApplicationController

  active_scaffold :lab do |config|
    config.list.columns = :patient, :date, :hct, :wbc, :esr, :blood_glucose, :malaria_smear, :urinalysis
  end
end
