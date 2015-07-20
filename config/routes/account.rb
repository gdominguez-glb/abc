namespace :account do
  root 'products#index'

  resources :favorites, only: [:index]

  get 'help', to: 'help#index'
  get 'help/qa/:id', to: 'help#qa', as: :qa

  get 'history', to: 'history#index'
  delete 'history/:id/remove', to: 'history#remove', as: :remove_history

  get 'settings', to: 'settings#index'
  patch 'save_profile', to: 'settings#save_profile'
  patch 'save_email_notifications', to: 'settings#save_email_notifications'

  resources :reminders, only: [:new, :create]

  resources :licenses do
    collection do
      post :assign
      get :import_modal
      post :import
      get :users
      get :reassign_modal
      post :reassign
    end
  end

  resources :notifications, only: [:index] do
    member do
      post :read
    end
  end
end
