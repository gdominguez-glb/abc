Deface::Override.new(
    virtual_path: "spree/admin/products/_form",
    name: "add_expiration_date_to_product_admin",
    insert_after: "[data-hook='admin_product_form_available_on']",
    text: "
          <div data-hook='admin_product_form_expiration_date'>
            <div class='form-group field' id='product_expiration_date_field'>
              <%= f.label :expiration_date %>
              <%= f.text_field :expiration_date, value: datepicker_field_value(@product.expiration_date), class: 'datepicker form-control' %>
            </div>
          </div>
"
)

Deface::Override.new(
    virtual_path: "spree/admin/products/new",
    name: "add_expiration_date_to_product_new",
    insert_after: "[data-hook='new_product_available_on']",
    text: "
          <div data-hook='new_product_expiration_date' class='col-md-4'>
            <div class='form-group field' id='product_expiration_date_field'>
              <%= f.label :expiration_date %>
              <%= f.text_field :expiration_date, value: datepicker_field_value(@product.expiration_date), class: 'datepicker form-control' %>
            </div>
          </div>
"
)
