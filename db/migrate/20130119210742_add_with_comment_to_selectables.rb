class AddWithCommentToSelectables < ActiveRecord::Migration
  def change
    add_column :symptoms, :with_comment, :boolean
    add_column :diagnoses, :with_comment, :boolean
    add_column :physicals, :with_comment, :boolean
  end
end
