Deface::Override.new(
    virtual_path: "spree/layouts/admin",
    name: "add_analytics_to_admin_sidebar",
    insert_bottom: "#main-sidebar",
    text: <<-HTML
      <% if can? :admin, current_store %>
        <ul class="nav nav-sidebar">
          <%= tab 'Analytics', url: spree.admin_analytics_path, icon: 'stats' %>
        </ul>
      <% end %>
    HTML
)
