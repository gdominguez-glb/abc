namespace :account do
  root to: 'root#index'

  get 'products', to: 'products#index'
  get 'resources', to: 'resources#index'

  get 'history', to: 'history#index'
  delete 'history/:id/remove', to: 'history#remove', as: :remove_history

  get 'settings', to: 'settings#index'
  patch 'save_profile', to: 'settings#save_profile'
  post 'save_grade_option', to: 'settings#save_grade_option'
  post 'ghost_login', to: 'settings#ghost_login'
  post 'ghost_back', to: 'settings#ghost_back'

  get :shop_of_interest, to: 'products#shop_of_interest'

  resources :reminders, only: [:new, :create]
  resources :recommendations, only: [:show]
  resources :whats_news, only: [:show]

  resources :licenses do
    collection do
      post :assign
      get :users
      get :export_users
      post :select_users
      get :edit_select_users
      get :user_stats
      get :licenses_stats
      get :edit_user_licenses
      post :update_user_licenses
      post :cancel_invitation
      post :revoke_all
    end
  end

  resources :notifications, only: [:index] do
    member do
      post :read
    end
  end

  resources :bookmarks

  resources :coupon_codes do
    collection do
      post :activate
    end
    member do
      post :activate_product
    end
  end

  get 'tour/dashboard', to: 'tour#dashboard'
  get 'tour/licenses', to: 'tour#licenses'
  get 'tour/licenses_users', to: 'tour#licenses_users'
end
