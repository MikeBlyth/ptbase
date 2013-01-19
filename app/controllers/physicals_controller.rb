class PhysicalsController < ApplicationController
  active_scaffold :physical do |config|
    config.label = "Physical Exam Features"
    %w(name label comments show_visits sort_order synonyms).each do |col|
      config.columns[col.to_sym].inplace_edit = true
    end
  end
end
