class AddHgbToHealthData < ActiveRecord::Migration
  def change
    add_column :health_data, :hemoglobin_type, :string
  end
end
