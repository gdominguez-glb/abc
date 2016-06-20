Deface::Override.new(
    virtual_path: "spree/layouts/admin",
    name: "add_credit_card_processor_menu_to_admin_sidebar",
    insert_bottom: "#main-sidebar",
    text: <<-HTML
      <% if can? :admin, Spree::Payment %>
        <ul class="nav nav-sidebar">
          <%= tab 'CC Order Processor', url: spree.new_admin_cc_order_path, icon: 'usd' %>
        </ul>
      <% end %>
    HTML
)
