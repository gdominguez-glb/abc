namespace :about do
	root to: 'root#index'

	get 'faq', to: 'faq#index'
	get 'faq/item/:id', to: 'faq#item', as: :help_item
	get 'faq/qa/:id', to: 'faq#qa' as: :qa

end
