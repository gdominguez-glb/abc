Deface::Override.new(:virtual_path => "spree/checkout/edit", 
                     :name => "remove_check_out_title", 
                     :replace => "[data-hook='checkout_title']", 
                     :text => "")
