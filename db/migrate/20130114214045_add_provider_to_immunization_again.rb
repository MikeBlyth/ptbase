class AddProviderToImmunizationAgain < ActiveRecord::Migration
  def change
    add_column :immunizations, :provider_id, :integer
  end
end
