Spree::Core::Engine.routes.prepend do
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
  end
  patch '/simple_cart', :to => 'orders#update_simple_cart', :as => :update_simple_cart
end
