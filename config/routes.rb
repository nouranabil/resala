Resala::Application.routes.draw do  
  resources :sessions, :only => [:new]
  resources :testimonials, :branches, :only => [:index, :show]
  resources :newsletter_subscribers, :only => [:create]
  resources :donation_requests, :feedbacks, :only => [:new, :create]
  resources :pages, :only => [:show, :user_info]
  resources :questions, :only => :index
  resources :activity_categories, :only => [:index,:show] do
    resources :questions, :only => :index
  end
  resources :activities, :only => [:show, :new, :create, :index]  do
    resources :achievements, :only => [:new, :create] 
    member do
      post :notify_comment
      get :join_activity
      post :quit
      get :volunteers
    end
  end
  resources :donations, :only=>[:new,:create,:index] do
    collection do
      get :handle_response
    end 
  end
  resources :news, :stories, :only => [:index, :show]  do
    collection do
      get 'search'
    end
  end
  resources :volunteers, :only => [:new, :create, :index, :show, :edit, :update] do 
    collection do
      post 'activities_authority'
      get 'request_activities_authority'
      get 'gateway'
    end
    member do
      get 'activities'
      get 'dashboard'
      get 'previous_activities'
      get 'upcoming_activities'
      get 'volunteer_details'
      post 'update_join_activity'
    end
    resources :activities, :only => []  do
      resources :achievements, :only => [:new, :create, :show] 
      member do
        get :volunteers
    	post :request_close
      	get :preview
      end
    end
  end
  
  namespace :admin do
    resources :activity_categories, :branches, :testimonials, :articles, :newsletter_subscribers, :achievements_types
    resources :donation_requests, :only => [:index, :show, :destroy, :update]
    resources :donations, :only => [:index]
    resources :activities, :only => [:index,:show,:update] do
      member do
        put 'publish'
        put 'announce'
        put 'reject'
        get 'members'
        put 'close'
      end
      collection do
        get 'email_counts'
      end
    end
    resources :volunteers, :only => [:index, :show, :edit, :update, :destroy] do 
      member do
        get 'authority_volunteer_details'
        post 'update_activities_authority_status'
      end
    end
    resources :admins, :only => [:index] do 
      member do
        post 'activate'
      end
    end
    resources :reports, :only=>[] do
      collection do
        get 'volunteers'
        get 'donations'
        get 'donation_requests'
      end
    end
    resources :questions, :except => [:show]
    match '/broadcast_email' => 'emails#new',    :as=>'new_bulk_email' , :via => :get
    match '/broadcast_email' => 'emails#create', :as=>'send_bulk_email', :via => :post
    match '/email_counts' => 'emails#email_counts', :as=>'email_counts', :via => :post
    match '/broadcast_email/preview' => 'emails#preview', :as=>'email_preview', :via=> :post
    match '/activity_categories/update_order/:id/:prev_id' => 'activity_categories#update_order', :as => :update_order, :via => :post
  end
  
  get "media/index"
  match '/auth/failure' => 'sessions#failure'
  match '/auth/:provider/callback' => 'sessions#create'
  match '/logout' => 'sessions#destroy', :as => :logout
  match '/admin_login/:provider' => 'sessions#admin_login', :as => :admin_login
  match '/login/:provider' => 'sessions#login', :as => :login
  match '/volunteering/:provider' => 'sessions#volunteering', :as => :volunteering
  match '/media(/:media_type)(/pages/:page)(.:format)' => 'media#index', :as=> 'media'
  match '/media/albums/:album_id/:media_type(/pages/:page)(.:format)' => 'media#index', :as=> 'album_photos'
  match '/media/:media_type/:fb_id(.:format)' => 'media#show', :as=> 'media_show'
  match '/admin' => 'admin/articles#index'
  match 'home' => 'pages#show', :id => :home
  match 'user_info' => 'pages#user_info'
  match '/volunteers/:id/activities/:activity_id' => 'volunteers#activity', :via => :get, :as=> 'volunteer_activity'
  match '/volunteers/:id/activities/:activity_id/edit' => 'activities#edit', :as=> 'edit_volunteer_activity'
  match '/volunteers/:id/activities/:activity_id' => 'activities#update', :via => :put, :as=> 'update_volunteer_activity'
  match '/subscribe_confirmation/:token' => 'newsletter_subscribers#subscribe_confirmation', :as=> 'subscribe_confirmation'
  match '/unsubscribe' => 'newsletter_subscribers#unsubscribe', :as=> 'unsubscribe'
  match '/unsubscribe_confirmation/:token' => 'newsletter_subscribers#unsubscribe_confirmation', :as=> 'unsubscribe_confirmation'
  match '/Adm!nD@ta$3cuReP@ge' => 'pages#admin_data_entry', :via=> :get, :as=> 'admin_data_entry'
  match '/update_admin_data' => 'pages#update_admin_data', :via=> :put
  root :to => 'pages#show', :id => :home
  
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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
