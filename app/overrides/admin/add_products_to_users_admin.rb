Spree::Core::Engine.routes.prepend do
  namespace :admin do
    resources :users do
      member do
        get :products
      end
    end
  end
end

Deface::Override.new(
    virtual_path: "spree/admin/users/_sidebar",
    name: "add_products_to_admin_users_sidebar",
    original: '6a17497f42b56e8b48abb8d68b5a397172b27cf1',
    insert_bottom: "[data-hook='admin_user_tab_options']",
    text: <<-HTML
      <li<%== ' class="active"' if current == :products %>>
        <%= link_to_with_icon 'products', Spree.t(:"admin.user.products"), spree.products_admin_user_path(@user) %>
      </li>
    HTML
)
