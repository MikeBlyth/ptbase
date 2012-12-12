class VisitsController < ApplicationController
  before_filter :authenticate_user!

  active_scaffold :visit do |config|
    config.list.columns = :patient, :date,:weight, :dx, :dx2, :meds, :adm
  end

end
