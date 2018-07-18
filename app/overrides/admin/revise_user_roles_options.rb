Deface::Override.new(:virtual_path => "spree/admin/users/_form", 
                     :name => "revise_user_roles_options", 
                     :replace_contents => "[data-hook='admin_user_form_roles']", 
                     :partial => "spree/admin/users/roles_options"
)
