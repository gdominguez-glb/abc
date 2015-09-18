namespace :account do
  root 'products#index'

  get 'help', to: 'help#index'
  get 'help/item/:id', to: 'help#item', as: :help_item
  get 'help/qa/:id', to: 'help#qa', as: :qa

  get 'history', to: 'history#index'
  delete 'history/:id/remove', to: 'history#remove', as: :remove_history

  get 'settings', to: 'settings#index'
  patch 'save_profile', to: 'settings#save_profile'
  post 'save_grade_option', to: 'settings#save_grade_option'

  resources :reminders, only: [:new, :create]

  resources :licenses do
    collection do
      post :assign
      get :import_modal
      post :import
      get :users
      get :export_users
      get :user_stats
      get :licenses_stats
      get :edit_user_licenses
      post :update_user_licenses
    end
  end

  resources :notifications, only: [:index] do
    member do
      post :read
    end
  end

  resources :bookmarks
end
