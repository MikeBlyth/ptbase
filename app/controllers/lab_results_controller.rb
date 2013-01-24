#require 'std_to_activescaffold_adapter'
class LabResultsController < ApplicationController
  active_scaffold :lab_result do |config|
    config.columns = [:patient, :lab_service, :date, :status, :result, :abnormal, :panic, :comments]
    config.columns[:lab_service].clear_link
    list.sorting = {:date => 'DESC'}
    config.columns[:date].inplace_edit = true
    config.columns[:status].inplace_edit = true
    config.columns[:status].options = {:options => [:pending, :recorded, :QNS, :error]}
    config.columns[:status].form_ui = :select
    config.columns[:result].inplace_edit = true
    config.columns[:abnormal].inplace_edit = true
    config.columns[:panic].inplace_edit = true
    config.columns[:comments].inplace_edit = true
    config.delete.link = false
    as_no_inline = lambda do |action|
      config.send(action).link.page = true
      config.send(action).link.inline = false
    end
    %w(create update ).each &as_no_inline
    # config.update.link.page = true # Note that if the update form is used, it will not work properly with
                                   # AS at this point.
  end

  def new
    @lab_result = LabResult.new(lab_request_id: params[:lab_request_id], patient_id: params[:patient_id]) #ToDO Error checking!
  end

  def create
    @lab_result = LabResult.new(params[:lab_result])
    # binding.pry
    if @lab_result.save
      flash[:notice] = "Created new lab_result #{@lab_result}"
      @record = @lab_result # ToDo -- only while AS is handling :show
      render :show
    else
      params=nil
      render :new
    end
  end

  def edit
    @lab_result = LabResult.find params[:id]
  end

  def update
    @lab_result = LabResult.find params[:id]
    if @lab_result.update_attributes(params[:lab_result])
      flash[:notice] = 'LabResult updated'
      redirect_to lab_result_path(@lab_result.id)
    else
      render :update
    end
  end


  def delete_authorized?(record)
    false
  end
#  include StdToActivescaffoldAdapter # NB THIS MUST COME *AFTER* THE active_scaffold configuration!

  #def update
  #  @record = LabResult.find params[:id]
  #  if @record.update_attributes(params[:lab_result])
  #    flash[:notice] = 'Lab result updated'
  #    puts "Request referer is #{request.referer}"
  #    redirect_to request.referer
  #  else
  #    render :edit
  #  end
  #end
end
