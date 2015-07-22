Deface::Override.new(
    virtual_path: "spree/admin/shared/_product_tabs",
    name: "add_materials_to_admin_product_tabs",
    insert_bottom: "[data-hook='admin_product_tabs']",
    text: <<-HTML
      <li class='<%= 'active' if current == 'Materials' %>'>
        <%= link_to_with_icon 'cloud', Spree.t(:materials), admin_product_materials_path(@product) %>
      </li>
    HTML
)
