Deface::Override.new(
    virtual_path: "spree/admin/products/new",
    name: "add_for_sale_to_product_new",
    insert_after: "[data-hook='new_product_available_on']",
    text: "
          <div data-hook='new_product_for_sale' class='col-md-4'>
            <div class='form-group field' id='product_for_sale_field'>
              <%= f.label :for_sale %>
              <%= f.check_box :for_sale, class: 'form-control' %>
            </div>
          </div>
"
)
