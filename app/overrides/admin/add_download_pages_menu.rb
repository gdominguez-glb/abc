Deface::Override.new(
    virtual_path: "spree/layouts/admin",
    name: "add_download_pages_to_admin_sidebar",
    insert_bottom: "#main-sidebar",
    text: <<-HTML
      <% if can? :admin, current_store %>
        <ul class="nav nav-sidebar">
          <%= tab 'Download Pages', url: spree.admin_download_pages_path, icon: 'lock' %>
        </ul>
      <% end %>
    HTML
)
