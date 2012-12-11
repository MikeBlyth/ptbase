class PrescriptionsController < ApplicationController
  active_scaffold :prescription do |config|
    config.list.columns = :patient, :date, :provider, :prescription_items
  end
end
