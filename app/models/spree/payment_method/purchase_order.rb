module Spree
  class PaymentMethod::PurchaseOrder < PaymentMethod
    def actions
      %w{capture void}
    end

    # Indicates whether its possible to capture the payment
    def can_capture?(payment)
      ['checkout', 'pending'].include?(payment.state)
    end

    # Indicates whether its possible to void the payment.
    def can_void?(payment)
      payment.state != 'void'
    end

    def capture(*args)
      ActiveMerchant::Billing::Response.new(true, "", {}, {})
    end

    def cancel(response); end

    def void(*args)
      ActiveMerchant::Billing::Response.new(true, "", {}, {})
    end

    def source_required?
      true
    end

    def auto_capture?
      true
    end

    def payment_source_class
      Spree::PurchaseOrder
    end

    def purchase(cents, source, gateway_options={})
      ActiveMerchant::Billing::Response.new(true, "", {}, {})
    end
  end
end
