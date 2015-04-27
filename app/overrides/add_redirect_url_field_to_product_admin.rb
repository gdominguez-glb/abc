Deface::Override.new(
    virtual_path: "spree/admin/products/_form",
    name: "add_redirect_url_field_to_product_admin",
    insert_bottom: "[data-hook='admin_product_form_additional_fields']",
    text: "
          <div data-hook='admin_product_form_redirect_url'>
            <div class='form-group field' id='product_redirect_url_field'>
              <%= f.label :redirect_to_partner_url %>
              <%= f.text_field :redirect_url, class: 'form-control' %>
            </div>
          </div>
"
)
