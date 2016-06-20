Deface::Override.new(
    virtual_path: "spree/layouts/admin",
    name: "add_videos_menu_to_admin_sidebar",
    insert_bottom: "#main-sidebar",
    text: <<-HTML
      <% if can? :admin, Spree::Video %>
        <ul class="nav nav-sidebar">
          <%= tab 'Videos', url: spree.admin_videos_path, icon: 'film' %>
        </ul>
      <% end %>
    HTML
)
