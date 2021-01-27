class Spree::PurchaseOrder < ApplicationRecord
  belongs_to :payment_method
  belongs_to :user, class_name: Spree.user_class.to_s, foreign_key: 'user_id'
  has_many :payments, as: :source

  # validates_presence_of :po_number

  def actions
    %w{capture void}
  end

  def can_capture?(payment)
    ['checkout', 'pending'].include?(payment.state)
  end

  def can_void?(payment)
    payment.state != 'void'
  end
end
