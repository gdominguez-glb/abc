spree_routes_overrides = Proc.new do
  namespace :admin do
    resources :school_districts, only: [:index]
    resources :videos
    resources :video_groups, only: [:index, :create]

    resources :curriculums do
      collection do
        post :update_positions
      end
    end

    resources :grades do
      member do
        get :grade_units_select
      end
      collection do
        post :update_positions
      end
      resources :grade_units do
        collection do
          post :update_positions
        end
      end
    end

    resources :users do
      member do
        get :licenses
      end
    end

    resources :licensed_products do
      collection do
        get :import
        post :import
      end
    end

    resources :products do
      resources :parts, only: [:index, :create, :destroy]
      resources :group_items, only: [:index, :create, :destroy]

      resources :materials do
        collection do
          get :bulk_modal
          post :bulk_create
        end
        member do
          post :update_position
          get :delete_confirm
        end
      end

      resources :material_import_jobs
      resource :inkling_code
    end

    resources :materials do
      resources :material_files
    end

    post '/sync_salesforce', to: 'salesforce#sync'
  end
  patch '/simple_cart', :to => 'orders#update_simple_cart', :as => :update_simple_cart
  get '/add_products_to_cart', to: 'orders#add_products_to_cart', as: :add_products_to_cart
  get '/products/:id/launch', to: 'products#launch', as: :launch_product
  get '/products/:id/terms', to: 'products#terms', as: :terms_product
  post '/products/:id/agree_terms', to: 'products#agree_terms', as: :agree_terms_product
  get '/products/group/:id', to: 'products#group', as: :group_product
end
if Rails.env.development?
  Spree::Core::Engine.add_routes(&spree_routes_overrides)
else
  Spree::Core::Engine.routes.prepend(&spree_routes_overrides)
end
