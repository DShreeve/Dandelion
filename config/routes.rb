Rails.application.routes.draw do
  
  
  resources :validations
  resources :data_types

  #Button for generating tests
  post "tables/download/:project_id/:id" => "tables#download"
  #new
  get 'projects/new' => 'projects#new'
  get 'projects/:project_id/tables/new' => 'tables#new'
  get 'projects/:project_id/tables/:table_id/fields/new' => 'fields#new'
  get 'projects/:project_id/tables/:table_id/fields/:field_id/validation_assignments/new' => 'validation_assignments#new'
  get 'projects/:project_id/tables/:table_id/fields/:field_id/validation_assignments/:validation_assignment_id/values/new' => 'values#new'
  
  #show => index
  get 'projects/:project_id' => 'tables#index'
  get 'projects/:project_id/tables/:table_id' => 'fields#index'
  get 'projects/:project_id/tables/:table_id/fields/:field_id' => 'validation_assignments#index'
  
  
  resources :projects do
    resources :tables do
      resources :fields do
        resources :validation_assignments do
          resources :values
        end
      end
    end
  end
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'projects#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
