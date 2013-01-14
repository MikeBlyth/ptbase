class LabRequestsController < ApplicationController
  active_scaffold :lab_request do |config|
    config.columns = [:patient, :date, :provider, :lab_results, :comments]
    config.columns[:provider].inplace_edit = true
    config.columns[:provider].form_ui = :select
    config.columns[:comments].inplace_edit = true
  end
end
