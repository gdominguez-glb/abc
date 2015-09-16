Deface::Override.new(
    virtual_path: "spree/shared/_products",
    name: "add_contact_form_banner_to_products_page",
    insert_before: "div#sidebar",
    text: '
    <div class="page-header">
      <h2>Bulk Order? Mixed Order?</h2>
      <p>Our experienced representatives are standing by to help you with your special order.
        <a href="" data-toggle="modal" data-target="#productContactForm">Contact us</a> today
      </p>
    </div>'
)

Deface::Override.new(
    virtual_path: "spree/shared/_products",
    name: "add_contact_form_to_products_page",
    insert_bottom: "div#products",
    partial: 'spree/products/contact-modal.html'
)
