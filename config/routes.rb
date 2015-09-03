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

  devise_scope :user do
    get 'become/:id', action: 'become',
                      controller: 'spree/user_sessions', as: 'become'
  end

  get 'contact', to: 'contact#index'

  get 'search', to: 'search#index'

  get 'events', to: 'events#index'
  get 'events/trainings', to: 'events#trainings', as: :events_trainings

  resources :video_gallery, only: [:index, :show] do
    member do
      get :show_description
      get :play
    end
  end

  get '/blog/global/:slug',          to: 'blog#global',          as: :global_blog
  get '/blog/global/:slug/post/:id', to: 'blog#global_post',     as: :global_post

  get '/:page_slug/blog/:slug',          to: 'blog#curriculum',      as: :curriculum_blog
  get '/:page_slug/blog/:slug/post/:id', to: 'blog#curriculum_post', as: :curriculum_post

  get '/decide_page_to_go', to: 'home#decide_page_to_go'

  get 'careers', to: 'jobs#index', as: :jobs
  get 'careers/:id', to: 'jobs#show', as: :job

  root 'home#index'

  resources :documents, only: [:show]

  draw :account
  draw :cms

  namespace :api do
    get 'user/info', to: 'user#info'
  end

  get '/:page_slug/events', to: 'events#page', as: :page_events

  get '/download_pages/:slug', to: 'download_pages#show', as: :download_page

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
    end
  end

  resources :download_jobs, only: [:show]

  get '*slug', to: 'pages#show', constraints: lambda { |request| !(request.path =~ /\/(assets|store).*/) }
end
