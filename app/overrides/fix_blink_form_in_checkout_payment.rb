Deface::Override.new(
  virtual_path: 'spree/checkout/_payment',
  name: 'fix_blink_form_in_checkout_payment_part1',
  replace: "#payment-method-fields",
  text: <<-HTML
    <ul class="list-group" id="payment-method-fields" style="<%= 'display: none;' if @payment_sources.count > 0 %>" data-hook>
      <% @order.available_payment_methods.each do |method| %>
        <li class="list-group-item">
          <label>
            <%= radio_button_tag "order[payments_attributes][][payment_method_id]", method.id, method == @order.available_payment_methods.first %>
            <%= Spree.t(method.name, :scope => :payment_methods, :default => method.name) %>
          </label>
        </li>
      <% end %>
    </ul>
  HTML
)

Deface::Override.new(
  virtual_path: 'spree/checkout/_payment',
  name: 'fix_blink_form_in_checkout_payment_part2',
  replace: "#payment-methods",
  text: <<-HTML
    <ul class="nav" id="payment-methods" style="<%= 'display: none;' if @payment_sources.count > 0 %>" data-hook>
      <% @order.available_payment_methods.each do |method| %>
        <li id="payment_method_<%= method.id %>" class="<%= 'last' if method == @order.available_payment_methods.last %>" style="display: none;" data-hook>
          <fieldset>
            <%= render partial: "spree/checkout/payment/"+method.method_type, locals: { payment_method: method } %>
          </fieldset>
        </li>
      <% end %>
    </ul>
  HTML
)
