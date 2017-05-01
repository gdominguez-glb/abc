namespace :about do

	get 'faq' => redirect('/faq')
	get 'faq/item/:id', to: 'faq#item', as: :faq_item
	get 'faq/qa/:id', to: redirect('/faq/%{id}')

end
