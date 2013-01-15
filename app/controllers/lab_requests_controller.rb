class LabRequestsController < ApplicationController
  active_scaffold :lab_request do |config|
    config.columns = [:patient, :date, :provider, :lab_results, :comments]
    config.columns[:provider].inplace_edit = true
    config.columns[:provider].form_ui = :select
    config.columns[:comments].inplace_edit = true
  end

  def create
    #   selected_services = params.delete(:services)
    add_services
    if @record = LabRequest.create(params[:lab_request])
      flash[:notice] = 'Successfully created lab request'
    else
      render :new
    end
  end

  def update
    #   selected_services = params.delete(:services)
    new_params = params[:lab_request]
    patient_id = new_params.delete(:patient_id)
    add_services
    if @record.update_attributes(new_params)
      flash[:notice] = 'Successfully updated'
    else
      render :new
    end
  end

  def add_services
    params[:lab_request][:lab_results_attributes] =
      (params[:services] || {}).keys.map {|s| {lab_service_id: s.to_i, status: :pending}}
  end

end
