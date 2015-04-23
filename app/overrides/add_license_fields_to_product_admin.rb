Deface::Override.new(
    virtual_path: "spree/admin/products/_form",
    name: "add_license_fields_to_product_admin",
    insert_bottom: "[data-hook='admin_product_form_additional_fields']",
    text: "
          <p>
                <%= f.label :license_text %>
                <%= f.text_area :license_text, class: 'form-control' %>
                <%= f.label :license_length_in_days %>
                <%= f.number_field :license_length, class: 'form-control' %>
          </p>
"
)
