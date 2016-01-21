Spree::FrontendHelper.class_eval do

  def flash_messages(opts = {})
    ignore_types = ["order_completed"].concat(Array(opts[:ignore_types]).map(&:to_s) || [])

    flash.each do |msg_type, text|
      unless ignore_types.include?(msg_type)
        concat(content_tag :div, text.html_safe, class: "alert alert-#{msg_type}")
      end
    end
    nil
  end

  def product_type_class(product)
    "product-type-#{product.curriculum.try(:name).downcase}" if product.curriculum.try(:name)
  end

  def product_display_price(product)
    price = display_price(product) unless product.product_type == "group" || product.product_type == "partner"
    price == "$0.00" ? "FREE" : price
  end

end