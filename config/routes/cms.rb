namespace :cms do
  root 'pages#index'

  get '/user_profile_settings', to: 'user_profile_settings#index'
  post '/user_profile_settings', to: 'user_profile_settings#save'

  get 'products/search', to: 'products#search'
  get 'users/search', to: 'users#search'

  resources :pages do
    collection do
      post :process_tiles
      get :published
      get 'published/:category', to: 'pages#published_category', as: :published_category
      get :drafts
      get 'drafts/:category', to: 'pages#drafts_category', as: :drafts_category
      get :archived
      get 'archived/:category', to: 'pages#archived_category', as: :archived_category
      get :search
    end
    member do
      post :publish
      get :preview
      post :archive
    end
  end
  resources :event_pages do
    collection do
      post :import_events
      get :published
      get :drafts
      get :archived
    end
    member do
      post :publish
      get :preview
    end
    resources :regonline_events, only: [:index, :edit, :update]
  end
  resources :documents
  resources :link_files
  resources :faq_categories do
    collection do
      post :update_positions
    end
  end
  resources :staffs do
    collection do
      post :update_positions
    end
  end
  resources :questions do
    collection do
      get :published
      get :drafts
      get :archived
    end
    member do
      post :publish
      get :preview
      post :archive
    end
  end
  resources :help_items
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
  resources :training_type_categories do
    resources :event_trainings do
      collection do
        post :update_positions
      end
    end
  end
  resources :download_pages do
    resources :download_products do
      collection do
        post :update_positions
      end
    end
  end
  resources :jobs do
    collection do
      post :update_positions
      get :published
      get :drafts
      get :archived
    end
    member do
      post :publish
      get :preview
    end
  end
  resources :footer_titles do
    collection do
      post :update_positions
    end
    resources :footer_links do
      collection do
        post :update_positions
      end
    end
  end
  resources :curriculum_mails
  resources :curriculum_shops
  resources :custom_csses
  resources :vanity_urls

  post 'sync', to: 'sync#run'
end
