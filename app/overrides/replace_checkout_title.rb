Deface::Override.new(:virtual_path => "spree/checkout/edit",
                     :name => "remove_check_out_title",
                     :replace => "[data-hook='checkout_title']",
                     :text => "<a href='/resources/cart' class='btn btn-block-xs btn-info'><i class='mi'>keyboard_arrow_left</i> Back to Cart</a>")
