Deface::Override.new(
    virtual_path: "spree/admin/users/edit",
    name: "remove_api_access_from_users_admin",
    remove: "[data-hook='admin_user_api_key']",
)
