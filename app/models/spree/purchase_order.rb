class Spree::PurchaseOrder < ActiveRecord::Base
  belongs_to :payment_method
  belongs_to :user, class_name: Spree.user_class, foreign_key: 'user_id'
  has_many :payments, as: :source

  validates_presence_of :po_number
end
