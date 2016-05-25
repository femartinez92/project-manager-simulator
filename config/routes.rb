Rails.application.routes.draw do
  devise_for :project_managers
  resources :cost_payment_plans
  resources :projects do
    resources :milestones do
      resources :tasks
    end
    resources :stakeholders do
      member do
        put 'increase_commitment'
      end
    end
  end

  # Routes for costs of tasks and project
    # Listar costos de un projecto
    get 'projects/:id/costs', to: 'projects#costs', as: 'project_costs'
    # Agregar costos desde las tareas
    get 'projects/:project_id/milestones/:milestone_id/tasks/:task_id/add_cost_line', to: 'tasks#add_cost_line', as: 'new_task_cost'
    post 'projects/:project_id/milestones/:milestone_id/tasks/:task_id/add_cost_line', to: 'tasks#create_cost_line', as: 'task_cost'
    # Pagar costos
    # get 'projects/:project_id/pay_cost/:cost_line_id', to: 'projects#insert_real_cost', as: 'set_real_cost'
    # post 'projects/:project_id/pay_cost/:cost_line_id', to: 'project#save_real_cost', as: 'pay_cost'

    # Clone projects, milestones and tasks
    post 'projects/:id/clone', to: 'projects#clone', as: 'clone_project'
    post 'projects/:project_id/milestones/clone', to: 'milestones#clone', as: 'clone_milestones'
    post 'projects/:project_id/milestones/:id/tasks/clone', to: 'tasks#clone', as: 'clone_tasks'

    # Task dependencies routes
    get 'projects/:project_id/precedents', to: 'milestones#precedent_index', as: 'precedents'
    post 'projects/:project_id/precedents', to: 'milestones#create_precedent', as: 'create_precedents'
    get 'projects/:project_id/precedents/new', to: 'milestones#new_precedent', as: 'new_precedents'
  

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
