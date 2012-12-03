ActiveAdmin.register Patient do
  index do
    column :last_name
    column :first_name
    column :other_names
    column :ident
    column :visits
    default_actions
  end

end
