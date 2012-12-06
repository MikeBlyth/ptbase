class AddProviderToAdmission < ActiveRecord::Migration
  def change
    add_column :admissions, :provider_id, :integer
    add_column :labs, :provider_id, :integer
    add_column :visits, :provider_id, :integer
  end
end
