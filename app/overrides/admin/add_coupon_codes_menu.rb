Deface::Override.new(
    virtual_path: "spree/layouts/admin",
    name: "add_coupon_codes_to_admin_sidebar",
    insert_bottom: "#main-sidebar",
    text: <<-HTML
      <% if can? :admin, current_store %>
        <ul class="nav nav-sidebar">
          <%= tab 'Product Keys', url: spree.admin_coupon_codes_path, icon: 'lock' %>
        </ul>
      <% end %>
    HTML
)
