Deface::Override.new(:virtual_path => "spree/shared/_order_details", 
                     :name => "fix_responsive_in_checkout", 
                     :surround => "[data-hook='order_details']",
                     :text => "<div class='table-responsive'><%= render_original %></div>")
