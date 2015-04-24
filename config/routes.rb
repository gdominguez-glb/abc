Rails.application.routes.draw do

  mount Spree::Core::Engine, at: '/store'

  devise_for :user,
             :class_name => 'Spree::User',
             :controllers => { :sessions => 'spree/admin/user_sessions',
                               :passwords => 'spree/admin/user_passwords' },
             :skip => [:unlocks, :omniauth_callbacks, :registrations],
             :path_names => { :sign_out => 'logout' }

  get 'contact', to: 'contact#index'
  post 'contact', to: 'contact#create'

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
  end

  get '/:slug', to: 'pages#show'

end
