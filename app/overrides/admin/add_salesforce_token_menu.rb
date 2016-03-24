Deface::Override.new(
  virtual_path: "spree/admin/shared/sub_menu/_configuration",
  name: "salesforce_token_admin_configurations_menu",
  insert_bottom: "[data-hook='admin_configurations_sidebar_menu']",
  text: "<%= configurations_sidebar_menu_item Spree.t(:salesforce_token), edit_admin_salesforce_token_url %>"
)
