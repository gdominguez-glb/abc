Rails.application.routes.draw do
  mount Spree::Core::Engine, at: '/store'

  devise_for :user,
             class_name: 'Spree::User',
             controllers: {
                            sessions: 'spree/admin/user_sessions',
                            passwords: 'spree/admin/user_passwords'
                          },
             skip: [:unlocks, :omniauth_callbacks, :registrations],
             path_names: {
                           sign_out: 'logout'
                         }

  get 'contact', to: 'contact#index'

  get 'video_demo', to: 'video_demo#index'

  get 'search', to: 'search#index'

  resources :video_gallery, only: [:index, :show] do
    member do
      get :show_description
      get :play
    end
    collection do
      get :s3_videos
      get :hosting_videos
    end
  end

  get '/account/help/qa/:id', to: 'account#help_qa', as: :qa
  delete '/account/remove_history/:id', to: 'account#remove_history', as: :remove_history
  resources :account, only: [:index] do
    collection do
      get :profile
      get :settings
      get :admin
      get :help
      get :favorites
      get :recommended
      get :history
      get :edit_profile
      patch :save_profile
      patch :save_email_notifications
    end
  end

  get '/blog/global/:slug',          to: 'blog#global',          as: :global_blog
  get '/blog/global/:slug/post/:id', to: 'blog#global_post',     as: :global_post

  get '/:page_slug/blog/:slug',          to: 'blog#curriculum',      as: :curriculum_blog
  get '/:page_slug/blog/:slug/post/:id', to: 'blog#curriculum_post', as: :curriculum_post

  root 'home#index'

  resources :documents, only: [:show]

  namespace :cms do
    root 'dashboard#index'
    get '/dashboard', to: 'dashboard#index', as: :dashboard

    get '/user_profile_settings', to: 'user_profile_settings#index'
    post '/user_profile_settings', to: 'user_profile_settings#save'

    get 'products/search', to: 'products#search'

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
  end

  get '*slug', to: 'pages#show',
    constraints: lambda { |request| !(request.path =~ /\/store.*/) }
end
