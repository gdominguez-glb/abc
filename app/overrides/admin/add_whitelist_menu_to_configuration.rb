Deface::Override.new(
    virtual_path: "resources/admin/whitelist",
    name: "add_tos_whitelist",
    insert_bottom: "[data-hook='admin_configurations_sidebar_menu']",
    text: "<%= configurations_sidebar_menu_item 'ToS Whitelist', admin_whitelist_index_path %>"
)
