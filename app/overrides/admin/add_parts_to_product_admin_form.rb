Deface::Override.new(
    virtual_path: "spree/admin/products/_form",
    name: "add_parts_to_product_admin_form",
    insert_bottom: "[data-hook='admin_product_form_additional_fields']",
    text: <<-HTML
      <% unless @product.parts? %>
        <div data-hook="admin_product_form_can_be_part">
          <%= f.field_container :can_be_part do %>
            <%= f.check_box :can_be_part %>
            <%= f.label :can_be_part, Spree.t('bundles.admin.label.products.can_be_part') %>
          <% end %>
        </div>

        <div data-hook="admin_product_form_individual_sale">
          <%= f.field_container :individual_sale do %>
            <%= f.check_box :individual_sale %>
            <%= f.label :individual_sale, Spree.t('bundles.admin.label.products.individual_sale') %>
          <% end %>
        </div>
      <% else %>
        <%= f.hidden_field :can_be_part, value: 0 %>
        <%= f.hidden_field :individual_sale, value: 1 %>
      <% end %>
    HTML
)
