Deface::Override.new(
    virtual_path: "spree/admin/products/_form",
    name: "add_salesforce_fields_to_product_admin",
    insert_bottom: "[data-hook='admin_product_form_additional_fields']",
    text: "
          <div data-hook='admin_product_form_sf_id_product'>
            <div class='form-group field' id='product_sf_id_product_field'>
              <%= f.label :sf_id_product %>
              <%= f.text_field :sf_id_product, class: 'form-control' %>
            </div>
          </div>
          <div data-hook='admin_product_form_sf_id_pricebook'>
            <div class='form-group field' id='product_sf_id_pricebook_field'>
              <%= f.label :sf_id_pricebook %>
              <%= f.text_field :sf_id_pricebook, class: 'form-control' %>
            </div>
          </div>
"
)

Deface::Override.new(
    virtual_path: "spree/admin/products/new",
    name: "add_salesforce_fields_to_product_new",
    insert_bottom: "[data-hook='new_product_attrs']",
    text: "
          <div data-hook='new_product_sf_id_product' class='col-md-4'>
            <div class='form-group field' id='product_sf_id_product_field'>
              <%= f.label :sf_id_product %>
              <%= f.text_field :sf_id_product, class: 'form-control' %>
            </div>
          </div>
          <div data-hook='admin_product_form_license_length' class='col-md-4'>
            <div class='form-group field' id='product_sf_id_pricebook_field'>
              <%= f.label :sf_id_pricebook %>
              <%= f.text_field :sf_id_pricebook, class: 'form-control' %>
            </div>
          </div>
"
)
