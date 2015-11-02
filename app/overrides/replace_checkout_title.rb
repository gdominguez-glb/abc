Deface::Override.new(:virtual_path => "spree/checkout/edit",
                     :name => "remove_check_out_title",
                     :replace => "[data-hook='checkout_title']",
                     :text => "<a href='/store/cart' class='btn btn-block-xs btn-info'><i class='fa fa-chevron-left'></i> Back to Cart</a>")
