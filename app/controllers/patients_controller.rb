require 'std_to_activescaffold_adapter'
require 'growth_chart'

class PatientsController < ApplicationController
  before_filter :authenticate_user!

  active_scaffold :patient do |config|
    config.columns.exclude :created_at, :updated_at
    config.list.columns = :ident, :last_name, :first_name, :other_names, :birth_date, :sex,
      :lab_results, :visits, :admissions, :prescriptions
    config.show.link.inline = false
    config.show.link.page = true
    config.update.link.inline = false
    config.update.link.page = true
    config.create.link.inline = false
    config.create.link.page = true

  end

#  include StdToActivescaffoldAdapter # NB THIS MUST COME *AFTER* THE active_scaffold configuration!

  def do_show
    super
  end

  def create
    @record = patient = Patient.new(params[:patient])
    if patient.save
      flash[:notice] = "Created new patient #{patient}"
      render :show
    else
      # render :create
    end
  end

  def update
    @record = patient = Patient.find params[:id]
    if patient.update_attributes(params[:patient])
      flash[:notice] = 'Patient updated'
      redirect_to patient_path(patient.id)
    else
      render :edit
    end
  end

  def growth_chart
    @patient = Patient.find params[:patient_id]
    chart = GrowthChart.new(@patient)
    @chart_script = chart.render_to_highchart
    render 'growth_chart_highchart'
  end

  def chart_data
    @patient = Patient.find params[:patient_id]
    chart = GrowthChart.new(@patient)
    chart.add_all_series
    chart.add_std_anthro_series
    chart.add_series chart.cd4_moderate_series
    chart.add_series chart.cd4_severe_series
    chart.add_series chart.cd4pct_severe_series
    render :json => chart.data_for_highchart
  end
end
