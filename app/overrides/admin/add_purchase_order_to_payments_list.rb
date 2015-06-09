Deface::Override.new(
    virtual_path: "spree/admin/payments/_list",
    name: "add_purchase_order_head_to_payments_list",
    insert_after: "[data-hook='payments_header'] th:nth-child(5)",
    text: <<-HTML
      <th class="text-center"><%= Spree.t(:p_o_number) %></th>
    HTML
)
Deface::Override.new(
    virtual_path: "spree/admin/payments/_list",
    name: "add_purchase_order_body_to_payments_list",
    insert_after: "[data-hook='payments_row'] td:nth-child(5)",
    text: <<-HTML
      <td class="text-center">
        <% if payment.source.is_a?(Spree::PurchaseOrder) %>
          <%= payment.source.po_number %>
          <% if payment.source.person_to_receive_license.present? %>
            / <%= payment.source.person_to_receive_license %>
          <% end %>
        <% end %>
      </td>
    HTML
)
