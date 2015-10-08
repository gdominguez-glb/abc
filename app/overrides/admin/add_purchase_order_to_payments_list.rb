Deface::Override.new(
    virtual_path: "spree/admin/payments/_list",
    name: "add_purchase_order_head_to_payments_list",
    insert_after: "[data-hook='payments_header'] th:nth-child(5)",
    text: <<-HTML
      <th class="text-center"><%= Spree.t(:p_o_number) %></th>
    HTML
)
