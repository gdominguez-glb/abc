Deface::Override.new(
    virtual_path: "spree/shared/_products",
    name: "add_contact_form_banner_to_products_page",
    insert_before: "div#products",
    text: '
    <div class="call-banner blue-bg">
      <h5>Bulk Order? Mixed Order?</h5>
      <h6>Our experienced representatives are standing by to help you with your special order.
        <a href="" data-toggle="modal" data-target="#productContactForm">Contact us</a> today
      <h6>
    </div>'
)

Deface::Override.new(
    virtual_path: "spree/shared/_products",
    name: "add_contact_form_to_products_page",
    insert_bottom: "div#products",
    partial: 'spree/products/contact-modal.html'
)
