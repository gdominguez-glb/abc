Deface::Override.new(
    virtual_path: "spree/checkout/_payment",
    name: "remove_coupon_from_payment",
    remove: "[data-hook='coupon_code']",
)
