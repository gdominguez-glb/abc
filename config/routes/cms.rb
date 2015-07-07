namespace :cms do
  root 'dashboard#index'
  get '/dashboard', to: 'dashboard#index', as: :dashboard

  get '/user_profile_settings', to: 'user_profile_settings#index'
  post '/user_profile_settings', to: 'user_profile_settings#save'

  get 'products/search', to: 'products#search'
  get 'users/search', to: 'users#search'

  resources :pages
  resources :documents
  resources :questions
  resources :contacts, only: [:index, :destroy, :edit, :update]
  resources :recommendations
  resources :medium_publications do
    collection do
      post :trigger_medium_importer
    end
  end
  resources :contact_topics do
    collection do
      post :update_positions
    end
  end
  resources :notification_triggers
  resources :curriculums
end
