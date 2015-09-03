spree_routes_overrides = Proc.new do
  namespace :admin do
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
        get :products
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
    end

    resources :materials do
      resources :material_files
    end
  end
  patch '/simple_cart', :to => 'orders#update_simple_cart', :as => :update_simple_cart
  post '/products/:id/favorite', to: 'products#favorite', as: :favorite_product
  get '/add_products_to_cart', to: 'orders#add_products_to_cart', as: :add_products_to_cart
end
if Rails.env.development?
  Spree::Core::Engine.add_routes(&spree_routes_overrides)
else
  Spree::Core::Engine.routes.prepend(&spree_routes_overrides)
end
