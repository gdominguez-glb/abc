Deface::Override.new(
    virtual_path: "spree/admin/products/new",
    name: "add_salesforce_fields_to_product_new",
    insert_after: "[data-hook='new_product_for_sale']",
    text: "
          <div data-hook='new_product_sf_id_product' class='col-md-4'>
            <div class='form-group field' id='product_sf_id_product_field'>
              <%= f.label :sf_id_product %><br /><%= t(:salesforce_field_note) %>
              <%= f.text_field :sf_id_product, class: 'form-control' %>
            </div>
          </div>
          <div data-hook='admin_product_form_license_length' class='col-md-4'>
            <div class='form-group field' id='product_sf_id_pricebook_field'>
              <%= f.label :sf_id_pricebook %><br /><%= t(:salesforce_field_note) %>
              <%= f.text_field :sf_id_pricebook, class: 'form-control' %>
            </div>
          </div>
"
)
