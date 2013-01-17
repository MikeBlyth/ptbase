#require 'std_to_activescaffold_adapter'
class LabResultsController < ApplicationController
  active_scaffold :lab_result do |config|
    config.columns = [:lab_service, :date, :status, :result, :abnormal, :panic, :comments]
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
    config.show.link = false
    config.delete.link = false
    config.update.link = false
    # config.update.link.page = true # Note that if the update form is used, it will not work properly with
                                   # AS at this point.
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
