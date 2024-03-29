Exlibris::Application.routes.draw do

  # deeply nested resources make for ugly long URLs
  # http://weblog.jamisbuck.org/2007/2/5/nesting-resources

  # this is the public navigation thingy whereby users can see each
  # others' books
  resources :users do
    resources :collections
    member do
      get 'friends', as: :friends
    end
  end
  resources :collections do
    resources :books
  end
  resources :books do
    collection do
      post 'organize'
    end
    member do
      post 'lend'
      post 'return'
    end
    resources :reviews
  end

  # this is the interface for users to edit their books
  resources :shelves do
    resources :books
  end

  resources :publications
  resources :reviews
  resources :editions
  resources :books

  match 'editions/isbn/:id' => "editions#isbn"

  match '/profile' => "users#me"

  match '/auth/:service/callback' => 'sessions#create'
  match '/logout' => 'sessions#destroy'
  match '/login' => 'sessions#new'

  match '/' => 'news#show'

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
