class LabRequestsController < ApplicationController
  active_scaffold :lab_request do |config|
    config.columns = [:patient, :date, :provider, :lab_results, :comments]
    config.columns[:provider].inplace_edit = true
    config.columns[:provider].form_ui = :select
    config.columns[:comments].inplace_edit = true
    as_no_inline = lambda do |action|
      config.send(action).link.page = true
      config.send(action).link.inline = false
    end
    %w(create update show).each &as_no_inline
  end

  def new
    @lab_request = LabRequest.new(patient_id: params[:patient_id],
                                  date: Date.zone.now)
  end

  def edit
    @lab_request = LabRequest.find params[:id]
    @patient = Patient.find @lab_request.patient_id
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
    @lab_request = lab_request.find(params[:id])
    if @lab_request.update_attributes(params[:lab_request])
      flash[:notice] = 'Lab request was successfully updated.'
      redirect_to :action => 'show', :id => @lab_request
    else
      render :action => 'edit'
    end
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

  # This is a bit unusual for an update controller. Although the lab request has many lab_results,
  # (which at this point are actually requests for a given lab service), the form only handles the
  # lab_service_ids and not the lab_result objects themselves, to avoid having to generate a large number
  # of objects just to allow them to be selected. The form does not even handle the lab_result ids,
  # only the service ids. This approach might need to be reworked completely
  # or refactored. Presently, we simply delete all the pending lab_results and add fresh all the
  # lab services specified in the incoming update form.
  # The associated lab_result records are added not directly but by inserting their ids into the
  # params hash in a way that causes them to be created via the accepts_nested_attributes feature.
  def update
    #   selected_services = params.delete(:services)
#binding.pry
    @record = LabRequest.find(params[:id])
    new_params = params[:lab_request]
    @record.lab_results.where(status: :pending).delete_all
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
