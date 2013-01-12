class LabResultsController < ApplicationController
  active_scaffold :lab_result do |config|
    config.list.columns = [:lab_service, :date, :status, :result, :abnormal, :panic]
  end
end
