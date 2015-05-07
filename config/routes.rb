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

  resources :video_gallery, only: [:index, :show] do
    member do
      get :show_description
      get :play
      post :add_favorite
    end
    collection do
      get :s3_videos
      get :hosting_videos
      post :set_player
    end
  end

  resources :account, only: [:index] do
    collection do
      get :profile
      get :settings
      get :admin
      get :help
      get :edit_profile
      patch :save_profile
    end
  end

  root 'home#index'

  resources :documents, only: [:show]

  namespace :cms do
    root 'dashboard#index'
    get '/dashboard', to: 'dashboard#index', as: :dashboard

    resources :pages
    resources :documents
    resources :contacts, only: [:index, :destroy, :edit, :update]
    resources :contact_topics do
      collection do
        post :update_positions
      end
    end
  end

  get '*slug', to: 'pages#show',
    constraints: lambda { |request| !(request.path =~ /\/store.*/) }
end
