class AddDateToLabRequest < ActiveRecord::Migration
  def change
    add_column :lab_requests, :date, :datetime
  end
end
