Deface::Override.new(
    virtual_path: "spree/shared/_products",
    name: "update_products_page_layout",
    set_attributes: ".product-list-item",
    attributes: {class: "product-list-item col-md-4 col-sm-6"}
)