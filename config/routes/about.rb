namespace :about do

	get 'faq', to: 'faq#index'
	get 'faq/item/:id', to: 'faq#item', as: :faq_item
	get 'faq/qa/:id', to: 'faq#qa', as: :qa

end
