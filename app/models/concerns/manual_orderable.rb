module ManualOrderable
  def add_line_items(order)
    products_quantity.each do |product_id, quantity|
      product = Spree::Product.find(product_id)
      order.line_items << Spree::LineItem.new(variant: product.master,
                                              quantity: quantity)
    end
  end

  def add_payments(order)
    order.payments << build_payment if payment_method_id.present?
    order.save
  end

  def process_order(order)
    count = 0
    while count < 6
      add_payments(order) if order.state == 'payment'
      order.next if order.state != 'complete'
      count += 1
    end
  end

  def build_payment
    payment_attributes = {
      amount: (amount || 0),
      payment_method_id: payment_method_id,
      source_attributes: payment_source_params[payment_method_id].permit!
    }
    Spree::Payment.new(payment_attributes)
  end
end
