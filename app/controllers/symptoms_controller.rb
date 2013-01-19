class SymptomsController < ApplicationController
  active_scaffold :symptom do |config|
    %w(name label comments show_visits sort_order synonyms with_comment).each do |col|
      config.columns[col.to_sym].inplace_edit = true
    end

  end
end

