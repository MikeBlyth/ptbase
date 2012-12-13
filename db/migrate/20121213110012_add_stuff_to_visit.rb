class AddStuffToVisit < ActiveRecord::Migration
  def change
    add_column :visits, :hpi, :text
    add_column :visits, :temperature, :float
    add_column :visits, :development, :text
    add_column :visits, :assessment, :text
    add_column :visits, :plan, :text
  end
end
