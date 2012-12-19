class AddPhysExamFieldsToVisit < ActiveRecord::Migration
  def up
    fields = %w(scalp conjunct eyes ears mouth nose chest heart abd liver spleen skin lymph extr neuro genitalia tanner)
    fields.each do |f|
      add_column :visits, "pe_#{f}_ok", :boolean
      add_column :visits, "pe_#{f}", :string
    end
  end
  def down

  end
end
