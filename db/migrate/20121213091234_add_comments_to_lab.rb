class AddCommentsToLab < ActiveRecord::Migration
  def change
    add_column :labs, :comment_hct, :string
    add_column :labs, :comment_cd4, :string
  end
end
