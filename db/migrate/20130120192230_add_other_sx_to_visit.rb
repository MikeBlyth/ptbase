class AddOtherSxToVisit < ActiveRecord::Migration
  def change
    add_column :visits, :other_symptoms, :string
  end
end
