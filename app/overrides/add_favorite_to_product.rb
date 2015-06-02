Deface::Override.new(
    virtual_path: "spree/products/show",
    name: "add_favorite_to_product",
    insert_after: "[data-hook='product_right_part_wrap']",
    text: <<-HTML
      <% if current_spree_user && current_spree_user.favorited_product?(@product) %>
        <button disabled='disabled' class="btn btn-primary">Added to Favorites</button>
      <% else %>
        <%= link_to 'Add to Favorites', spree.favorite_product_path(@product, {ref_id: '#favorite-button'}), class: 'btn btn-primary', id: "favorite-button", remote: true, data: { method: :post } %>
        <% end %>
    HTML
)
