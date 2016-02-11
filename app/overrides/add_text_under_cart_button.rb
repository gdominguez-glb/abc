Deface::Override.new(
    virtual_path: "spree/products/_cart_form",
    name: "add_text_under_cart_button",
    insert_after: "#inside-product-cart-form",
    text: <<-HTML
      <% unless @product.free? %>
        <p class="alert alert-info">To purchase more than 15 licenses or to pay with a purchase order, <a class="product-alert-link" href="/contact#sales">contact us</a>.</p>
      <% end %>
    HTML
)
