spree_routes_overrides = Proc.new do
  namespace :admin do
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
      resources :materials
    end
  end
  patch '/simple_cart', :to => 'orders#update_simple_cart', :as => :update_simple_cart
  post '/products/:id/favorite', to: 'products#favorite', as: :favorite_product
end
if Rails.env.development?
  Spree::Core::Engine.add_routes(&spree_routes_overrides)
else
  Spree::Core::Engine.routes.prepend(&spree_routes_overrides)
end
