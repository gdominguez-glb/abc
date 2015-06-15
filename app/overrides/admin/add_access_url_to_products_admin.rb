Deface::Override.new(
    virtual_path: "spree/admin/products/_form",
    name: "add_access_url_to_product_admin",
    insert_bottom: "[data-hook='admin_product_form_additional_fields']",
    text: "
          <div data-hook='admin_product_form_access_url'>
            <div class='form-group field' id='product_access_url_field'>
              <%= f.label :access_url %>
              <%= f.text_field :access_url, class: 'form-control' %>
            </div>
          </div>
"
)

Deface::Override.new(
    virtual_path: "spree/admin/products/new",
    name: "add_access_url_to_product_new",
    insert_bottom: "[data-hook='new_product_attrs']",
    text: "
          <div data-hook='new_product_access_url' class='col-md-4'>
            <div class='form-group field' id='product_access_url_field'>
              <%= f.label :access_url %>
              <%= f.text_field :access_url, class: 'form-control' %>
            </div>
          </div>
"
)
