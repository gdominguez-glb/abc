Deface::Override.new(
    virtual_path: "spree/admin/products/_form",
    name: "add_is_grades_product_to_product_admin",
    insert_after: "[data-hook='admin_product_form_available_on']",
    text: "
          <div data-hook='admin_product_form_is_grades_product'>
            <div class='form-group field' id='product_is_grades_product_field'>
              <%= f.label :is_grades_product %>
              <%= f.check_box :is_grades_product, class: 'form-control' %>
              <p class='help-block'>This is used to decide filter grades in download page</p>
            </div>
          </div>
"
)

Deface::Override.new(
    virtual_path: "spree/admin/products/new",
    name: "add_is_grades_product_to_product_new",
    insert_after: "[data-hook='new_product_available_on']",
    text: "
          <div data-hook='new_product_is_grades_product' class='col-md-4'>
            <div class='form-group field' id='product_is_grades_product_field'>
              <%= f.label :is_grades_product %>
              <%= f.check_box :is_grades_product, class: 'form-control' %>
              <p class='help-block'>This is used to decide filter grades in download page</p>
            </div>
          </div>
"
)
