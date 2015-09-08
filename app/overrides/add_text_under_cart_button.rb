Deface::Override.new(
    virtual_path: "spree/products/_cart_form",
    name: "add_text_under_cart_button",
    insert_after: "#inside-product-cart-form",
    text: <<-HTML
      <% unless @product.free? %>
        <p>If you would like to purchase more than 15 licenses of this product, please <a href="/contact">contact us</a>.</p>
      <% end %>
    HTML
)
