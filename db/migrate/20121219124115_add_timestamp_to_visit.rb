class AddTimestampToVisit < ActiveRecord::Migration
  def change
    add_column :visits, :created_at, :datetime
    add_column :visits, :updated_at, :datetime
  end
end
