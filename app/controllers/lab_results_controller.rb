class LabResultsController < ApplicationController
  active_scaffold :lab_result do |config|
    config.columns = [:lab_service, :date, :status, :result, :abnormal, :panic, :comments]
    config.columns[:lab_service].clear_link
    config.columns[:date].inplace_edit = true
    config.columns[:status].inplace_edit = true
    config.columns[:status].options = {:options => [:pending, :recorded, :QNS, :error]}
    config.columns[:status].form_ui = :select
    config.columns[:result].inplace_edit = true
    config.columns[:abnormal].inplace_edit = true
    config.columns[:panic].inplace_edit = true
    config.columns[:comments].inplace_edit = true
  end
end
