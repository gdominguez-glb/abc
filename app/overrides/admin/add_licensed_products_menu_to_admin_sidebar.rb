Deface::Override.new(
    virtual_path: "spree/layouts/admin",
    name: "add_licensed_products_to_admin_sidebar",
    insert_bottom: "#main-sidebar",
    text: <<-HTML
      <ul class="nav nav-sidebar">
        <%= tab 'Licenses', url: spree.admin_licensed_products_path, icon: 'lock' %>
      </ul>
    HTML
)
