Deface::Override.new(
    virtual_path: "spree/products/_cart_form",
    name: "add_text_under_cart_button",
    insert_after: "#inside-product-cart-form",
    text: <<-HTML
      <% unless @product.free? %>
        <p class="alert alert-info"><i class="mi">info_outline</i> If you would like to purchase more than 15 licenses of this product or pay with a purchase order, please <a href="/contact#sales">contact us</a>.</p>
      <% end %>
    HTML
)
