class DiagnosesController < ApplicationController
  active_scaffold :diagnosis do |config|
    %w(name label comments show_visits sort_order synonyms).each do |col|
      config.columns[col.to_sym].inplace_edit = true
    end
  end
end
