ActionController::Routing::Routes.draw do |map|
  
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  map.resources :activity_types
  map.resources :awards, :except => [ :destroy ],
    :member => { :versions => :get, :revert => :post, :details => :get },
    :collection => { :incomplete => :get, :update_ctsa_reporting_year => :post }
  map.resources :ctsa_reports, :except => [ :show ],
    :member => { :download => :get }
  map.resources :publications, :only => [ :edit, :update, :new, :create ],
    :member => { :versions => :get, :revert => :post },
    :collection => { :incomplete => :get, :update_ctsa_reporting_year => :post }
  map.resources :approvals, :only => [ :index ],
    :collection => { :update_approvals => :post }
  map.resources :organizational_units
  
  map.resources :services, 
    :member     => { :choose_service_line => :get, :choose_person => :get, :update_person => :put, :update_approvals => :put, 
                     :continue => [:get, :put], :identified => [:get, :put], :surveyable => :get, :survey => :post,
                     :create_service_for_person => :post,
                     :choose_awards => :get, :choose_organizational_units => :get, :choose_publications => :get, :choose_approvals => :get }, 
    :collection => { :choose_service_line => :get, :choose_person => :get, :my_services => :get }
  
  map.resources :people, :only => [:index, :edit, :update, :new, :create], 
    :member     => { :versions => :get, :revert => :post, :version => :get, :merge => [:get, :post] },
    :collection => { :upload => [:get, :post], :search => [:get,:post], :search_results => [:get,:post], 
                     :directory => [:get, :post], :incomplete => :get, :update_ctsa_reporting_year => :post,
                     :era_commons_username_search => [:get, :post] } do |people|
      people.resources :awards
      people.resources :publications
      people.resources :approvals
      people.resources :services
  end
  map.resources :clients, :controller => "people"
  map.resources :contacts, :collection => { :upload => [:get, :post], :email_search => [:get], :load_contact => [:get], :sample_upload_file => :get }
  map.resources :contact_lists
  
  map.resources :participating_organizations
  map.resources :service_lines

  map.resources :users, :except => [ :destroy, :show ]

  map.connect 'reports/:action', :controller => "reports"
  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "welcome"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end
