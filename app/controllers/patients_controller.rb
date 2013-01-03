require 'std_to_activescaffold_adapter'
require 'growth_chart'

class PatientsController < ApplicationController
  before_filter :authenticate_user!

  active_scaffold :patient do |config|
    config.columns.exclude :created_at, :updated_at
    config.list.columns = :ident, :last_name, :first_name, :other_names, :birth_date, :sex,
      :labs, :visits, :admissions, :prescriptions
    config.show.link.inline = false
    config.show.link.page = true

  end

  include StdToActivescaffoldAdapter # NB THIS MUST COME *AFTER* THE active_scaffold configuration!

  def do_show
    super
    chart = GrowthChart.new(@record)
    chart.add_all_series
    chart.add_std_anthro_series
    chart.add_series chart.cd4_moderate_series
    chart.add_series chart.cd4_severe_series
    chart.add_series chart.cd4pct_severe_series
    @chart_data = chart.data_for_morris
  end

  def growth_chart
    @patient = Patient.find params[:patient_id]
    chart = GrowthChart.new(@patient)
    chart.add_all_series
    chart.add_std_anthro_series
    chart.add_series chart.cd4_moderate_series
    chart.add_series chart.cd4_severe_series
    chart.add_series chart.cd4pct_severe_series
    @chart_data = chart.data_for_morris
    render 'growth_chart_highchart'
  end
end
