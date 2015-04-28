Deface::Override.new(
    virtual_path: "spree/products/_cart_form",
    name: "replace_add_to_cart_button",
    replace_contents: ".add-to-cart .input-group-btn",
    original: '6278b026da0521317687f6ffe9be242eaa1f4e8e',
    text: <<-HTML
            <% if @product.redirect_url.present? %>
              <%= link_to Spree.t(:purchase_from_partner), @product.redirect_url, class: 'btn btn-success' %>
            <% else %>
              <%= button_tag :class => 'btn btn-success', :id => 'add-to-cart-button', :type => :submit do %>
                <%= Spree.t(:add_to_cart) %>
              <% end %>
            <% end %>
    HTML
)
