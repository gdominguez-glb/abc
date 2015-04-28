Deface::Override.new(
    virtual_path: "spree/admin/products/_form",
    name: "add_license_fields_to_product_admin",
    insert_bottom: "[data-hook='admin_product_form_additional_fields']",
    text: "
          <div data-hook='admin_product_form_license_text'>
            <div class='form-group field' id='product_license_text_field'>
              <%= f.label :license_text %>
              <%= f.text_area :license_text, class: 'form-control' %>
            </div>
          </div>
          <div data-hook='admin_product_form_license_length'>
            <div class='form-group field' id='product_license_length_field'>
              <%= f.label :license_length_in_days %>
              <%= f.number_field :license_length, class: 'form-control' %>
            </div>
          </div>
"
)

Deface::Override.new(
    virtual_path: "spree/admin/products/new",
    name: "add_license_fields_to_product_new",
    insert_bottom: "[data-hook='new_product_attrs']",
    text: "
          <div data-hook='new_product_license' class='col-md-4'>
            <div class='form-group field' id='product_license_text_field'>
              <%= f.label :license_text %>
              <%= f.text_area :license_text, class: 'form-control' %>
            </div>
          </div>
          <div data-hook='admin_product_form_license_length' class='col-md-4'>
            <div class='form-group field' id='product_license_length_field'>
              <%= f.label :license_length_in_days %>
              <%= f.number_field :license_length, class: 'form-control' %>
            </div>
          </div>
"
)
