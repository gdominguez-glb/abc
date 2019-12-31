class ActionDispatch::Routing::Mapper
  def draw(routes_name)
    instance_eval(File.read(Rails.root.join("config/routes/#{routes_name}.rb")))
  end
end

class VanityUrlConstraint
  def self.matches?(request)
    VanityUrl.find_by(url: request.original_url).present?
  end
end

class LinkUploadsConstraint
  def initialize(domain)
    @domains = [domain].flatten
  end

  def matches?(request)
    @domains.include?(request.domain.downcase) if request.domain.present?
  end
end

Rails.application.routes.draw do

  require 'sidekiq/web'

  authenticate :spree_user, lambda { |u| u.has_admin_role? } do
    mount Sidekiq::Web => '/sidekiq'
    mount Flipper::UI.app($flipper) => '/admin/flipper'
  end

  mount Nkss::Engine => '/styleguides'

  use_doorkeeper

  get '/saml/auth' => 'saml_idp#new'
  get '/saml/metadata' => 'saml_idp#show'
  post '/saml/auth' => 'saml_idp#create'
  match '/saml/logout' => 'saml_idp#logout', via: [:get, :post, :delete]

  mount Spree::Core::Engine, at: '/resources'

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
    get 'become/:id', action: 'become', controller: 'spree/user_sessions', as: 'become'
    get 'lti', action: 'lti', controller: 'spree/user_sessions', as: 'lti'
    get '/resources/signup/:title/:interest', action: :new, controller: 'spree/user_registrations', as: :custom
  end

  get 'terms-of-service', to: 'terms_of_service#display', as: :display_terms
  post 'terms-of-service', to: 'terms_of_service#accept', as: :accept_terms

  get 'privacy-policy', to: 'pages#privacy_policy'

  get 'famis/:record_id', to: 'famis#show'

  get 'contact', to: 'contact#index'
  post 'contact', to: 'contact#create', as: :create_contact

  get 'search', to: 'search#index'
  get 'search/:id/product', to: 'search#product', as: :search_product

  get 'events', to: 'events#index'
  get 'events/trainings', to: 'events#trainings', as: :events_trainings
  get 'events/:parent_slug/trainings', to: 'events#trainings_by_parent', as: :parent_events_trainings
  get 'events/trainings/:category', to: 'events#trainings_by_category', as: :category_events_trainings
  get 'events/l/:slug', to: 'events#list', as: :events_list

  resources :video_gallery, only: [:index, :show] do
    member do
      get :show_description
      get :play
      get :unlock
      post :bookmark
      post :remove_bookmark
    end
  end

  get '/updates/global/:slug',          to: 'blog#global',          as: :global_blog
  get '/updates/global/:slug/post/:id', to: 'blog#global_post',     as: :global_post

  get '/:page_slug/blog/:slug',          to: 'blog#curriculum',      as: :curriculum_blog
  get '/:page_slug/blog/:slug/post/:id', to: 'blog#curriculum_post', as: :curriculum_post

  get '/:page_slug/events/:slug',        to: 'events#curriculum',    as: :curriculum_events

  post '/blog/:id/subscribe', to: 'blog#subscribe', as: :subscribe_blog
  post '/blog/:id/unsubscribe', to: 'blog#unsubscribe', as: :unsubscribe_blog

  get '/turn_off_browser_warning', to: 'home#turn_off_browser_warning'
  get '/decide_page_to_go', to: 'home#decide_page_to_go'
  post '/set_filter_preferences', to: 'home#set_filter_preferences'

  get 'careers', to: 'jobs#index', as: :jobs
  get 'careers/:id', to: 'jobs#show', as: :job

  resources :team, only: [:index, :show] do
    collection do
      get :trustees
    end
  end

  root 'home#index'

  resources :documents, only: [:show]

  draw :about
  draw :account
  draw :cms

  get 'faq', to: 'faq#index'
  get 'faq/:id', to: 'faq#qa', as: :qa

  namespace :api do
    get 'user/info', to: 'user#info'
    post 'user', to: 'user#create'
    post 'order', to: 'order#create'
    post 'data/sync', to: 'data#sync'
  end

  get '/:page_slug/events', to: 'events#page', as: :page_events

  get '/download_pages/:slug', to: 'download_pages#show', as: :download_page
  get '/testimonials_video/:wistia_video_id', to: 'pages#testimonials_video', as: :testimonials_video
  get '/facebook_video', to: 'pages#facebook_video', as: :facebook_video

  resources :inkling_codes, only: [:show]
  resources :libraries, only: [:show] do
    member do
      get '/launch/:item_id', action: :launch, as: :launch_item
      get '/download/:item_id', action: :download, as: :download_item
    end
  end

  resources :flipbooks, only: [:show] do
    member do
      get '/launch/:item_id', action: :launch, as: :launch_item
      get '/download/:item_id', action: :download, as: :download_item
    end
  end

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
  resources :newsletters, only: [:index, :create]
  resources :opportunities, only: [:index, :create]
  resources :school_districts, only: [:index, :show]
  resources :fall_institute_pds, only: [:new, :create]

  get 'not-found', to: 'pages#not_found', as: :not_found

  constraints VanityUrlConstraint do
    get '*slug', to: 'vanity_urls#show'
  end

  constraints LinkUploadsConstraint.new('witeng.link') do
    get '*slug', to: 'wit_eng#show', as: :wit_eng_link, :constraints => { :slug => /[^\/]+/ }
  end

  get '*slug', to: 'pages#show', as: :page, constraints: lambda { |request| !(request.path =~ /\/(assets|resources).*/) }
end
