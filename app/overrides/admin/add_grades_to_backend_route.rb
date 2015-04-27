Spree::Core::Engine.routes.prepend do
  namespace :admin do
    resources :grades
  end
end

Deface::Override.new(:virtual_path => "spree/admin/shared/sub_menu/_configuration",
                     :name => "add_grades_to_configurations",
                     :insert_bottom => "[data-hook='admin_configurations_sidebar_menu']",
                     :text => "<%= configurations_sidebar_menu_item(Spree.t(:grades), spree.admin_grades_path) %>",
                     :disabled => false)
