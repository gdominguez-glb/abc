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
      post :unarchive
      post :copy_page
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
      post :archive
      post :unarchive
    end
    resources :regonline_events, only: [:index, :new, :create, :edit, :update]
    resources :regonline_event_headers
  end
  resources :documents do
    member do
      post :copy_doc
    end
  end
  resources :link_files
  resources :faq_categories do
    collection do
      post :update_positions
    end
  end
  resources :faq_category_headers
  resources :staffs do
    collection do
      get :trustees
      get :emeritus_advisors
      post :update_positions
    end
  end
  resources :questions do
    collection do
      get :published
      get :drafts
      get :archived
      get :search
    end
    member do
      post :publish
      get :preview
      post :archive
      post :unarchive
    end
  end
  resources :help_items
  resources :contacts, only: [:index, :destroy, :edit, :update]
  resources :recommendations do
    member do
      get :preview
    end

    collection do
      get :search
    end
  end
  resources :whats_news
  resources :in_the_news do
    collection do
      get :edit_page
      post :save_page
      get :search
      post :update_positions
    end
  end
  resources :data_stories, only: [:index] do
    collection do
      post :save_page
    end
  end
  resources :medium_publications do
    collection do
      post :trigger_medium_importer
    end
  end
  resources :blogs do
    resources :subscribers, only: [:index] do
      collection do
        get :export
      end
    end
    resources :articles do
      collection do
        get :published
        get :drafts
        get :archived
        get :search
      end
      member do
        post :publish
        get :preview
        post :archive
        post :unarchive
      end
    end
  end
  resources :contact_topics do
    collection do
      post :update_positions
    end
  end
  resources :notification_triggers do
    collection do
      post :target_users_count
    end
  end
  resources :curriculums
  resources :training_type_categories do
    resources :event_training_headers
    resources :event_trainings do
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
      post :archive
      post :unarchive
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
  resources :custom_fields do
    collection do
      post :update_positions
    end
  end
  resources :popups, except: [:show]
  resources :fall_institute_pds, only: [:index]
end
