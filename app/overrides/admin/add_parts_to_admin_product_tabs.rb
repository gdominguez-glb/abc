Deface::Override.new(
    virtual_path: "spree/admin/shared/_product_tabs",
    name: "add_parts_to_admin_product_tabs",
    insert_bottom: "[data-hook='admin_product_tabs']",
    text: <<-HTML
      <%= content_tag :li, class: ('active' if current == Spree.t('bundles.admin.sidebar')) do %>
        <%= link_to_with_icon 'puzzle-piece', Spree.t('bundles.admin.sidebar'), admin_product_parts_path(@product) %>
      <% end %>
    HTML
)
