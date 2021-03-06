Ptbase::Application.routes.draw do

  resources :immunization_types do as_routes end

  resources :physicals do as_routes end

  resources :symptoms do as_routes end

  resources :lab_results do as_routes end

  resources :lab_groups do as_routes end

  resources :lab_services do as_routes end

  resources :lab_requests do as_routes end

  resources :icd9s do as_routes end

  resources :problems do as_routes end

  resources :health_data do as_routes end

  match '/growth_chart/:patient_id', to: 'patients#growth_chart'
  match 'patients/:patient_id/chart_data', to: 'patients#chart_data'

  resources :providers do as_routes end

  # resources :users do as_routes end   # Will probably be handled by authentication program

  resources :photos do as_routes end

  resources :labs do as_routes end

  resources :admissions do as_routes end

  match '/prescriptions/select', :to => 'prescriptions#select'

  resources :prescriptions do as_routes end

  match '/patients/:patient_id/prescriptions/new', :to => 'prescriptions#new'

  resources :prescription_items do as_routes end

  resources :pictures do as_routes end

  resources :immunizations do as_routes end

  resources :drug_preps do as_routes end

  resources :drugs do as_routes end

  resources :diagnoses do as_routes end

  resources :visits do as_routes end
  post '/visits/new', to: 'visits#create'
  put '/visits/:id/edit', to: 'visits#update'

  resources :patients do as_routes end

  devise_for :users, path_names: {sign_in: 'login', sign_out: 'logout'}

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
   root :to => 'patients#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
