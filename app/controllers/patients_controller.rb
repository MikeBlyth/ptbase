class PatientsController < ApplicationController
  before_filter :authenticate_user!

  active_scaffold :patient do |config|
    config.columns.exclude :created_at, :updated_at
    config.list.columns = :ident, :last_name, :first_name, :other_names, :birth_date, :sex,
      :labs, :visits, :admissions, :prescriptions
  end

end
