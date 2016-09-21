namespace :cms do
  root 'pages#index'

  get '/user_profile_settings', to: 'user_profile_settings#index'
  post '/user_profile_settings', to: 'user_profile_settings#save'

  get 'products/search', to: 'products#search'
  get 'users/search', to: 'users#search'

  resources :pages do
    collection do
      post :process_tiles
    end
    member do
      get :product_marketing_editor
      post :publish
      post :update_tiles
    end
  end
  resources :event_pages do
    collection do
      post :import_events
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
  resources :questions
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
