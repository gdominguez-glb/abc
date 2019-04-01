Deface::Override.new(
    virtual_path: "spree/admin/shared/sub_menu/_configuration",
    name: "add_tos_whitelist",
    insert_bottom: "[data-hook='admin_configurations_sidebar_menu']",
    text: "<%= configurations_sidebar_menu_item 'ToS Whitelist', admin_whitelist_index_path %>"
)
