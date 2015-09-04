Deface::Override.new(
    virtual_path: "spree/admin/products/_form",
    name: "add_video_group_to_products_admin",
    insert_after: "[data-hook='admin_product_form_available_on']",
    text: "
          <div data-hook='admin_product_form_video_group'>
            <div class='form-group field' id='product_video_group'>
              <%= f.label :video_group %>
              <%= f.collection_select :video_group_id, Spree::VideoGroup.all, :id, :name, { prompt: 'select video group' }, class: 'form-control' %>
            </div>
          </div>
"
)
