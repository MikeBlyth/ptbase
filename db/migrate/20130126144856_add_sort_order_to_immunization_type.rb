class AddSortOrderToImmunizationType < ActiveRecord::Migration
  def change
    add_column :immunization_types, :sort_order, :integer
  end
end
