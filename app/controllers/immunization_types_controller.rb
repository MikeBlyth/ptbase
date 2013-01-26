class ImmunizationTypesController < ApplicationController
  active_scaffold :immunization_type do |config|
    config.columns.exclude :immunizations
    %w(name abbrev sort_order notes).each {|col| config.columns[col].inplace_edit = true}
  end
end
