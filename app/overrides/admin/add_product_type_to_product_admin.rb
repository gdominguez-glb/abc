Deface::Override.new(
    virtual_path: "spree/admin/products/new",
    name: "add_product_type_to_product_new",
    insert_bottom: "[data-hook='new_product_attrs']",
    text: <<-HTML
      <div data-hook="new_product_product_type" class="col-md-4">
        <%= f.field_container :product_type, :class => ['form-group'] do %>
          <%= f.label :product_type, Spree.t(:product_type) %>
          <%= f.select(:product_type, Spree::Product::PRODUCT_TYPES, { :include_blank => Spree.t('match_choices.none') }, { :class => 'select2' }) %>
          <%= f.error_message_on :product_type %>
        <% end %>
      </div>
    HTML
)

Deface::Override.new(
    virtual_path: "spree/admin/products/_form",
    name: "add_product_type_to_product_admin",
    insert_bottom: "[data-hook='admin_product_form_additional_fields']",
    text: <<-HTML
      <div data-hook="admin_product_form_product_type">
        <%= f.field_container :product_type, class: ['form-group'] do %>
          <%= f.label :product_type, Spree.t(:product_type) %>
          <%= f.select(:product_type, Spree::Product::PRODUCT_TYPES, { :include_blank => Spree.t('match_choices.none') }, { :class => 'select2' }) %>
          <%= f.error_message_on :product_type %>
        <% end %>
      </div>
    HTML
)
