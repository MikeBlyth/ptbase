class SelectableItemsController < ApplicationController
  active_scaffold self.class.to_s[0..-11].singularize.downcase.to_sym do |config|
    %w(name label comments show_visits sort_order synonyms).each do |col|
      config.columns[col.to_sym].inplace_edit = true
    end
  end
end
