class ActionDispatch::Routing::Mapper
  def draw(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes/#{routes_name}.rb")))
  end
end

Rails.application.routes.draw do
  require 'sidekiq/web'
  authenticate :spree_user, lambda { |u| u.has_admin_role? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  mount Nkss::Engine => '/styleguides'
  use_doorkeeper
  mount Spree::Core::Engine, at: '/store'

  devise_for :spree_user,
             class_name: 'Spree::User',
             controllers: {
                            sessions: 'spree/admin/user_sessions',
                            passwords: 'spree/admin/user_passwords'
                          },
             skip: [:unlocks, :omniauth_callbacks, :registrations],
             path_names: {
                           sign_out: 'logout'
                         }

  devise_scope :spree_user do
    get 'become/:id', action: 'become',
                      controller: 'spree/user_sessions', as: 'become'
  end

  get 'contact', to: 'contact#index'

  get 'search', to: 'search#index'
  get 'search/:id/product', to: 'search#product', as: :search_product

  get 'events', to: 'events#index'
  get 'events/trainings', to: 'events#trainings', as: :events_trainings
  get 'events/l/:slug', to: 'events#list', as: :events_list

  resources :video_gallery, only: [:index, :show] do
    member do
      get :show_description
      get :play
      get :unlock
      post :bookmark
    end
  end

  get '/updates/global/:slug',          to: 'blog#global',          as: :global_blog
  get '/updates/global/:slug/post/:id', to: 'blog#global_post',     as: :global_post

  get '/:page_slug/blog/:slug',          to: 'blog#curriculum',      as: :curriculum_blog
  get '/:page_slug/blog/:slug/post/:id', to: 'blog#curriculum_post', as: :curriculum_post

  get '/:page_slug/events/:slug',        to: 'events#curriculum',    as: :curriculum_events

  get '/decide_page_to_go', to: 'home#decide_page_to_go'

  get 'careers', to: 'jobs#index', as: :jobs
  get 'careers/:id', to: 'jobs#show', as: :job

  resources :staffs, only: [:index, :show] do
    collection do
      get :trustees
    end
  end

  root 'home#index'

  resources :documents, only: [:show]

  draw :about
  draw :account
  draw :cms

  namespace :api do
    get 'user/info', to: 'user#info'
  end

  get '/:page_slug/events', to: 'events#page', as: :page_events

  get '/download_pages/:slug', to: 'download_pages#show', as: :download_page

  resources :inkling_codes, only: [:show]

  resources :materials do
    collection do
      post :download_all
      post :multi_download
      post :track
      post :untrack
    end
    member do
      get :download
      get :download_all
      get :preview
      post :bookmark
      post :remove_bookmark
    end
  end

  resources :download_jobs, only: [:show]

  get '*slug', to: 'pages#show', constraints: lambda { |request| !(request.path =~ /\/(assets|store).*/) }
end
