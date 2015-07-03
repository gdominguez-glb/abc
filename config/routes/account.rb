namespace :account do
  root 'products#index'

  resources :favorites, only: [:index]

  get 'help', to: 'help#index'
  get 'help/qa/:id', to: 'help#qa', as: :qa

  get 'history', to: 'history#index'
  delete 'history/:id/remove', to: 'history#remove', as: :remove_history

  get 'settings', to: 'settings#index'
  patch 'save_profile', to: 'settings#save_profile'
  patch 'save_email_notifications', to: 'settings#save_email_notifications'

  get 'admin', to: 'admin#index'
  get 'admin/import_licenses', to: 'admin#import_licenses'
  post 'admin/import_licenses', to: 'admin#import_licenses'
  get 'admin/distributions', to: 'admin#distributions'
end
