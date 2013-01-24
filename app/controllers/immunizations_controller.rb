class ImmunizationsController < ApplicationController
  active_scaffold :immunization do |config|
    as_no_inline = lambda do |action|
      config.send(action).link.page = true
      config.send(action).link.inline = false
    end
    %w(create update).each &as_no_inline
    %w(date provider immunization_type comments).each {|col| config.columns[col].inplace_edit = true}
    %w(provider immunization_type).each {|col| config.columns[col].form_ui = :select}
  end

  def new
    @immunization = Immunization.new(patient_id: params[:patient_id], provider_id: params[:provider_id],
        date: Date.current)
  end

  def edit
    @immunization = Immunization.find params[:id]
  end

  def create
    @immunization = Immunization.new(params[:immunization])
    if @immunization.save
      flash[:notice] = 'immunization was successfully created.'
      redirect_to :action => 'show', :id => @immunization
    else
      render :action => 'edit'
    end
  end

  def update
    @immunization = immunization.find(params[:id])
    if @immunization.update_attributes(params[:immunization])
      flash[:notice] = 'immunization was successfully updated.'
      redirect_to :action => 'show', :id => @immunization
    else
      render :action => 'edit'
    end
  end

end
