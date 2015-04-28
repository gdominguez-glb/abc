Spree::Core::Engine.routes.prepend do
  namespace :admin do
    resources :curriculums do
      collection do
        post :update_positions
      end
    end
  end
end

Deface::Override.new(
  virtual_path: "spree/admin/shared/sub_menu/_configuration",
  name: "add_curriculums_to_configurations",
  original: 'd55e094287c32bca40fae7c49fabb9e143f4afd8',
  insert_bottom: "[data-hook='admin_configurations_sidebar_menu']",
  text: "<%= configurations_sidebar_menu_item(Spree.t(:curriculums), spree.admin_curriculums_path) %>",
  disabled: false
)
