Deface::Override.new(
    virtual_path: "spree/admin/products/new",
    name: "add_image_to_product_new",
    insert_after: "[data-hook='product-from-prototype']",
    text: <<-HTML
      <div data-hook="new_product_image">
        <div class="form-group">
          <label>Image</label>
          <input type="file" name="product[new_image]"/>
        </div>
      </div>
    HTML
)
